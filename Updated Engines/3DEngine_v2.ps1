Add-Type -AssemblyName  Microsoft.VisualBasic, PresentationCore, PresentationFramework, System.Drawing, System.Windows.Forms, WindowsBase, WindowsFormsIntegration, System;
iwr -Uri "https://raw.githubusercontent.com/jh1sc/Powershell-SetFont/main/SetFont.psm1" -OutFile SetFont.psm1; ipmo .\SetFont.psm1
$sig = '[DllImport("user32.dll")] public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);'; Add-Type -MemberDefinition $sig -name NativeMethods -namespace Win32
(Get-Process Powershell).MainWindowHandle | ForEach-Object { [Win32.NativeMethods]::ShowWindowAsync($_, 3) } | out-null
$host.UI.RawUI.ForegroundColor = "White"
$host.UI.RawUI.BackgroundColor = "Black"
SetFontAsp 0 8 8 48 400 Terminal
[int]$nScreenWidth = 240;[int]$nScreenHeight = 123
$host.UI.RawUI.WindowSize = [Management.Automation.Host.Size]::new(($nScreenWidth),($nScreenHeight))
$host.UI.RawUI.BufferSize = [Management.Automation.Host.Size]::new(($nScreenWidth),($nScreenHeight))

$script:Vertexs = @(); $script:Faces = @()
function LFF ($scale) {
    $script:Vertexs = @(); $script:Faces = @()
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog; $OpenFileDialog.InitialDirectory; $OpenFileDialog.FileName; $OpenFileDialog.ShowDialog() | out-null
    $objFile = Get-Content $OpenFileDialog.FileName; $lines = $objFile -split "`n"
    foreach ($line in $lines) {
        $parts = $line -split " "
        switch ($parts[0]) {
            "v" {
                $vertex = [pscustomobject]@{
                    x = ([float]$parts[1] * $scale)
                    y = ([float]$parts[2] * $scale)
                    z = ([float]$parts[3] * $scale)
                }
                $script:Vertexs += $vertex 
            }
            "f" {
                $face = [pscustomobject]@{
                    v1 = [float]$parts[1] - 1
                    v2 = [float]$parts[2] - 1
                    v3 = [float]$parts[3] - 1
                }
                $script:Faces += $face
            }
        }
    }
}
function ASKS {
    param ([string]$Char)
    $signature = 
    @"
	[DllImport("user32.dll", CharSet=CharSet.Auto, ExactSpelling=true)]
	public static extern short GetAsyncKeyState(int virtualKeyCode);
"@
    $GetAsyncKeyState = Add-Type -MemberDefinition $signature -Name "Win32GetAsyncKeyState" -Namespace Win32Functions -PassThru
    return $GetAsyncKeyState::GetAsyncKeyState([System.Windows.Forms.Keys]::$Char)
}


function Toggle($value) {
    switch ($value) {
        1 {
            $script:triframe = $true
            $script:trifill = $true
        }
        2 {
            $script:triframe = $false
            $script:trifill = $true
        }
        3 {
            $script:triframe = $true
            $script:trifill = $false
        }
    }
}
[string[]]$screen = @(" " * $nScreenWidth) * $nScreenHeight
$script:scale = 10
LFF $script:scale
$LP = [pscustomobject]@{x = -40; y = -40; z = -40 }
$Cam = [pscustomobject]@{x = 0; y = 0; z = -80 }
$LI = 1.9
$Fov = 80
$TriAccr = 0.9
$ShadeIndex = "MQW#BNqpHERmKdgAGbX8@SDOPUkwZyF69heT0a&xV%Cs4fY52Lonz3ucJjvItr}{li?1][7<>=)(+*|!/\;:-,_~^.'"
$refr = @(" " * $nScreenWidth) * $nScreenHeight
$theta = 0.09; $cosTheta = [System.Math]::Cos($theta); $sinTheta = [System.Math]::Sin($theta)
$script:triframe = $true
$script:trifill = $true
$WFchar = "."



Clear-Host
$sw = [Diagnostics.Stopwatch]::New()
while ($true) {
    $sw.Restart()
    $screen = $refr
    $ui = @(
    ("          Made By Jh1sc          ")
    ("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=")
    ("  W - rotate around x axis(+) ")
    ("  S - rotate around x axis(-) ")
    ("  A - rotate around y axis(+) ")
    ("  D - rotate around y axis(-) ")
    ("  Q - rotate around z axis(+) ")
    ("  E - rotate around z axis(-) ")
    ("  UP arrow - Translate Modely(+) ")
    ("  DOWN arrow - Translate Modely(-)   ")
    ("  LEFT arrow - Translate Modelx(+) ")
    ("  RIGHt arrow - Translate Modelx(-)   ")
    ("  Z - scale(+) ")
    ("  X  - scale(-)   ")
    ("  L - Load new Model  ")
    ("  T - Toggle Render Settings  ")
    ("  TriFrame:$triframe - TriFill:$trifill   ")
    ("  Scale:$script:scale   ")
    ("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="))

    if (ASKS("L")) { LFF 10 }
    if (ASKS("W")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $y = $Vertexs[$j].y; $z = $Vertexs[$j].z; $Vertexs[$j].y = $y * $cosTheta - $z * $sinTheta; $Vertexs[$j].z = $y * $sinTheta + $z * $cosTheta } }
    if (ASKS("S")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $y = $Vertexs[$j].y; $z = $Vertexs[$j].z; $Vertexs[$j].y = $y * $cosTheta + $z * $sinTheta; $Vertexs[$j].z = $z * $cosTheta - $y * $sinTheta } }
    if (ASKS("A")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $x = $Vertexs[$j].x; $z = $Vertexs[$j].z; $Vertexs[$j].x = $x * $cosTheta + $z * $sinTheta; $Vertexs[$j].z = $z * $cosTheta - $x * $sinTheta } }
    if (ASKS("D")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $x = $Vertexs[$j].x; $z = $Vertexs[$j].z; $Vertexs[$j].x = $x * $cosTheta - $z * $sinTheta; $Vertexs[$j].z = $z * $cosTheta + $x * $sinTheta } }
    if (ASKS("Q")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $x = $Vertexs[$j].x; $y = $Vertexs[$j].y; $Vertexs[$j].x = $x * $cosTheta - $y * $sinTheta; $Vertexs[$j].y = $x * $sinTheta + $y * $cosTheta } }
    if (ASKS("E")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $x = $Vertexs[$j].x; $y = $Vertexs[$j].y; $Vertexs[$j].x = $x * $cosTheta + $y * $sinTheta; $Vertexs[$j].y = $y * $cosTheta - $x * $sinTheta } }

    if (ASKS("Up")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $Vertexs[$j].y -= 1 } }
    if (ASKS("Down")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $Vertexs[$j].y += 1 } }

    if (ASKS("Left")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $Vertexs[$j].x -= 1 } }
    if (ASKS("Right")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $Vertexs[$j].x += 1 } }



    if (ASKS("Z")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $Vertexs[$j].x *= 1.1; $Vertexs[$j].y *= 1.1; $Vertexs[$j].z *= 1.1 } $script:scale *= 1.1 }
    if (ASKS("X")) { for ($j = 0; $j -lt $Vertexs.Length; $j++) { $Vertexs[$j].x *= 0.9; $Vertexs[$j].y *= 0.9; $Vertexs[$j].z *= 0.9 }  $script:scale *= 0.9 }
    if (ASKS("T")) { if ($toggle -gt "3") { $toggle = 0 }$toggle += 0.2; Toggle $toggle }
    for ($t = 0; $t -lt $Faces.length; $t++) {
        $x1 = $Vertexs[$Faces[$t].v1].x; $y1 = $Vertexs[$Faces[$t].v1].y; $z1 = $Vertexs[$Faces[$t].v1].z
        $x2 = $Vertexs[$Faces[$t].v2].x; $y2 = $Vertexs[$Faces[$t].v2].y; $z2 = $Vertexs[$Faces[$t].v2].z
        $x3 = $Vertexs[$Faces[$t].v3].x; $y3 = $Vertexs[$Faces[$t].v3].y; $z3 = $Vertexs[$Faces[$t].v3].z
        $normalx = ($y2 - $y1) * ($z3 - $z1) - ($z2 - $z1) * ($y3 - $y1)
        $normaly = ($z2 - $z1) * ($x3 - $x1) - ($x2 - $x1) * ($z3 - $z1)
        $normalz = ($x2 - $x1) * ($y3 - $y1) - ($y2 - $y1) * ($x3 - $x1)
        $l = [math]::sqrt($normalx * $normalx + $normaly * $normaly + $normalz * $normalz)
        $normalx /= $l; $normaly /= $l; $normalz /= $l
        $dot = $normalx * ($x1 - $Cam.x) + $normaly * ($y1 - $Cam.y) + $normalz * ($z1 - $Cam.z) 
        if ($dot -lt 0) {
            $x1 = [math]::round(($x1 * ($Fov / ($Fov + $z1))) + $nScreenWidth / 2)
            $y1 = [math]::round(($y1 * ($Fov / ($Fov + $z1))) + $nScreenHeight / 2)
            $x2 = [math]::round(($x2 * ($Fov / ($Fov + $z2))) + $nScreenWidth / 2)
            $y2 = [math]::round(($y2 * ($Fov / ($Fov + $z2))) + $nScreenHeight / 2)
            $x3 = [math]::round(($x3 * ($Fov / ($Fov + $z3))) + $nScreenWidth / 2)
            $y3 = [math]::round(($y3 * ($Fov / ($Fov + $z3))) + $nScreenHeight / 2)
            if ($trifill -eq $true) {
                if (($x1 -lt $nScreenWidth -and $y1 -lt $nScreenHeight -and $x2 -lt $nScreenWidth -and $y2 -lt $nScreenHeight -and $x3 -lt $nScreenWidth -and $y3 -lt $nScreenHeight) -and ($x1 -gt 0 -and $y1 -gt 0 -and $x2 -gt 0 -and $y2 -gt 0 -and $x3 -gt 0 -and $y3 -gt 0)) {
                    $lightVector = [math]::Sqrt(($LP.X - $x1) * ($LP.X - $x1) + ($LP.Y - $y1) * ($LP.Y - $y1) + ($LP.Z - $z1) * ($LP.Z - $z1))
                    $objectNormal = [math]::Sqrt($x1 * $x1 + $y1 * $y1 + $z1 * $z1)
                    $cosAngle = ($lightVector * $lightVector + $objectNormal * $objectNormal - $lightVector * $objectNormal) / (2 * $lightVector * $objectNormal)
                    $shading = [Math]::Max(0, [Math]::Min(([Math]::Round(($cosAngle / $LI) * ($ShadeIndex.Length - 1))), $ShadeIndex.Length - 1))
                    [char]$shade = $ShadeIndex[$shading]
                    if ($y2 -lt $y1) { ($x1, $y1, $x2, $y2) = ($x2, $y2, $x1, $y1) }
                    if ($y3 -lt $y1) { ($x1, $y1, $x3, $y3) = ($x3, $y3, $x1, $y1) }
                    if ($y3 -lt $y2) { ($x2, $y2, $x3, $y3) = ($x3, $y3, $x2, $y2) }
                    [double] $slope1 = ($x2 - $x1) / ($y2 - $y1)
                    [double] $slope2 = ($x3 - $x1) / ($y3 - $y1)
                    [double] $slope3 = ($x3 - $x2) / ($y3 - $y2)
                    for ([double] $scanlineY = $y1; $scanlineY -le $y2; $scanlineY += $TriAccr) {
                        [double] $startX = $x1 + ($scanlineY - $y1) * $slope1
                        [double] $endX = $x1 + ($scanlineY - $y1) * $slope2
                        if ($startX -gt $endX) { ($endX, $startX) = ($startX, $endX) }
                        for ([double] $scanlineX = $startX; $scanlineX -le $endX; $scanlineX += $TriAccr) {
                            $screen[$scanlineY] = $screen[$scanlineY].Remove($scanlineX, 1); $screen[$scanlineY] = $screen[$scanlineY].Insert($scanlineX, $shade)
                        }
                    }
                    for ([double] $scanlineY = $y2; $scanlineY -le $y3; $scanlineY += $TriAccr) {
                        [double] $startX = $x2 + ($scanlineY - $y2) * $slope3
                        [double] $endX = $x1 + ($scanlineY - $y1) * $slope2
                        if ($startX -gt $endX) { ($endX, $startX) = ($startX, $endX) }
                        for ([double] $scanlineX = $startX; $scanlineX -le $endX; $scanlineX += $TriAccr) {
                            $screen[$scanlineY] = $screen[$scanlineY].Remove($scanlineX, 1); $screen[$scanlineY] = $screen[$scanlineY].Insert($scanlineX, $shade)
                        }
                    }   
                }
            }
            if ($triframe -eq $true) {
                if (($x1 -lt $nScreenWidth -and $y1 -lt $nScreenHeight -and $x2 -lt $nScreenWidth -and $y2 -lt $nScreenHeight -and $x3 -lt $nScreenWidth -and $y3 -lt $nScreenHeight) -and ($x1 -gt 0 -and $y1 -gt 0 -and $x2 -gt 0 -and $y2 -gt 0 -and $x3 -gt 0 -and $y3 -gt 0)) {
                    $x11 = $x1; $y11 = $y1; $x22 = $x2
                    $y22 = $y2; $x33 = $x3; $y33 = $y3
                    $dx = $x2 - $x1
                    $dy = $y2 - $y1
                    $dx = [math]::abs($dx)
                    $dy = [math]::abs($dy)
                    $sx = $x1 - $x2
                    $sy = $y1 - $y2
                    if ($x1 -lt $x2) { $sx = 1 } else { $sx = -1 }
                    if ($y1 -lt $y2) { $sy = 1 } else { $sy = -1 }
                    $err = $dx - $dy
                    while ($true) {
                        $screen[$y1] = $screen[$y1].Remove($x1, 1); $screen[$y1] = $screen[$y1].Insert($x1, $WFchar)
                        if (($x1 -eq $x2) -and ($y1 -eq $y2)) { break }
                        $e2 = 2 * $err
                        if ($e2 -gt - $dy) { $err = $err - $dy; $x1 = $x1 + $sx }
                        if ($e2 -lt $dx) { $err = $err + $dx; $y1 = $y1 + $sy }
                    }
                    $y3 = $y33; $y2 = $y22
                    $x3 = $x33; $x2 = $x22
                    $dx = $x3 - $x2
                    $dy = $y3 - $y2
                    $dx = [math]::abs($dx)
                    $dy = [math]::abs($dy)
                    $sx = $x2 - $x3
                    $sy = $y2 - $y3
                    if ($x2 -lt $x3) { $sx = 1 } else { $sx = -1 }
                    if ($y2 -lt $y3) { $sy = 1 } else { $sy = -1 }
                    $err = $dx - $dy
                    while ($true) {
                        $screen[$y2] = $screen[$y2].Remove($x2, 1); $screen[$y2] = $screen[$y2].Insert($x2, $WFchar)
                        if (($x2 -eq $x3) -and ($y2 -eq $y3)) { break }
                        $e2 = 2 * $err
                        if ($e2 -gt - $dy) { $err = $err - $dy; $x2 = $x2 + $sx }
                        if ($e2 -lt $dx) { $err = $err + $dx; $y2 = $y2 + $sy }
                    }
                    $y1 = $y11; $y3 = $y33
                    $x1 = $x11; $x3 = $x33
                    $dx = $x1 - $x3
                    $dy = $y1 - $y3
                    $dx = [math]::abs($dx)
                    $dy = [math]::abs($dy)
                    $sx = $x3 - $x1
                    $sy = $y3 - $y1
                    if ($x3 -lt $x1) { $sx = 1 } else { $sx = -1 }
                    if ($y3 -lt $y1) { $sy = 1 } else { $sy = -1 }
                    $err = $dx - $dy
                    while ($true) {
                        $screen[$y3] = $screen[$y3].Remove($x3, 1); $screen[$y3] = $screen[$y3].Insert($x3, $WFchar)
                        if (($x3 -eq $x1) -and ($y3 -eq $y1)) { break }
                        $e2 = 2 * $err
                        if ($e2 -gt - $dy) { $err = $err - $dy; $x3 = $x3 + $sx }
                        if ($e2 -lt $dx) { $err = $err + $dx; $y3 = $y3 + $sy }
                    }
                }
            }
        }
    }
    $spr = $ui
    $x = 3; $y = 3
    for ($i = 0; $i -lt $spr.length; $i++) {
        for ($j = 0; $j -lt $spr[$i].length; $j++) {
            $screen[$y + $i] = $screen[$y + $i].Remove($x + $j, 1); $screen[$y + $i] = $screen[$y + $i].Insert($x + $j, $spr[$i][$j])
        }
    }
    $sw.Stop()
    $fps = [math]::Round(10000000 / $sw.ElapsedTicks)
    [system.console]::title = "3D ENGINE - Made by: Jh1sc - FPS: $fps"
    [console]::setcursorposition(0, 0)
    [console]::write([string]::Join("`n", $screen))
}