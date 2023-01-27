Add-Type -AssemblyName  Microsoft.VisualBasic, PresentationCore, PresentationFramework, System.Drawing, System.Windows.Forms, WindowsBase, WindowsFormsIntegration, System;
[int]$nScreenWidth = 240
[int]$nScreenHeight = 124
[string[]]$screen = @(" " * $nScreenWidth) * $nScreenHeight
$host.UI.RawUI.BufferSize = New-Object Management.Automation.Host.Size($nScreenWidth, $nScreenHeight)
$host.UI.RawUI.WindowSize = New-Object Management.Automation.Host.Size($nScreenWidth, $nScreenHeight)
iwr -Uri "https://raw.githubusercontent.com/jh1sc/Powershell-SetFont/main/SetFont.psm1" -OutFile SetFont.psm1; ipmo .\SetFont.psm1
$ErrorActionPreference = 'SilentlyContinue'
SetFontAsp 0 8 8 48 400 Terminal
$file = Read-Host "Obj File Path (No Quotes)"
$objFile = Get-Content $file
$lines = $objFile -split "`n"
$vertexes = @()
$faces = @()


foreach ($line in $lines) {
    $parts = $line -split " "
    switch ($parts[0]) {
        "v" {
            $vertex = [pscustomobject]@{
                x = [float]$parts[1]
                y = [float]$parts[2]
                z = [float]$parts[3]
            }
            $vertexes += $vertex
        }
        "f" {
            $face = [pscustomobject]@{
                v1 = [float]$parts[1] - 1
                v2 = [float]$parts[2] - 1
                v3 = [float]$parts[3] - 1
            }
            $faces += $face
        }
    }
}
$Vertexs = $vertexes; $Faces = $faces



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

for ($j = 0; $j -lt $Vertexs.length; $j++) {
    $Vertexs[$j].x *= 10
    $Vertexs[$j].y *= 10
    $Vertexs[$j].z *= 10
}

$lightPosition = [pscustomobject]@{x = 20; y = 0; z = 0 }
$vCamera = [pscustomobject]@{x = 0; y = 0; z = -80 }
$ShadeIndex = "MQW#BNqpHERmKdgAGbX8@SDOPUkwZyF69heT0a&xV%Cs4fY52Lonz3ucJjvItr}{li?1][7<>=)(+*|!/\;:-,_~^.'"
$lightIntensity = 1
$sw = [Diagnostics.Stopwatch]::New()
$distance = 80

$refr = @(" " * $nScreenWidth) * $nScreenHeight
    
$theta = 0.09
$cosTheta = [System.Math]::Cos($theta)
$sinTheta = [System.Math]::Sin($theta)
SetFontAsp 0 3 5 54 400 Consolas
while ($true) {
    $sw.Restart()
    $screen = $refr



    if (ASKS("W")) {
        #rotate around x axis
        for ($j = 0; $j -lt $Vertexs.Length; $j++) {
            $y = $Vertexs[$j].y
            $z = $Vertexs[$j].z
            $Vertexs[$j].y = $y * $cosTheta - $z * $sinTheta
            $Vertexs[$j].z = $y * $sinTheta + $z * $cosTheta
        }
    }

    if (ASKS("S")) {
        #rotate around x axis
        for ($j = 0; $j -lt $Vertexs.Length; $j++) {
            $y = $Vertexs[$j].y
            $z = $Vertexs[$j].z
            $Vertexs[$j].y = $y * $cosTheta + $z * $sinTheta
            $Vertexs[$j].z = $z * $cosTheta - $y * $sinTheta
        }
    }

    if (ASKS("A")) {
        #rotate around y axis
        for ($j = 0; $j -lt $Vertexs.Length; $j++) {
            $x = $Vertexs[$j].x
            $z = $Vertexs[$j].z
            $Vertexs[$j].x = $x * $cosTheta + $z * $sinTheta
            $Vertexs[$j].z = $z * $cosTheta - $x * $sinTheta
        }
    }
    
    if (ASKS("D")) {
        #rotate around y axis
        for ($j = 0; $j -lt $Vertexs.Length; $j++) {
            $x = $Vertexs[$j].x
            $z = $Vertexs[$j].z
            $Vertexs[$j].x = $x * $cosTheta - $z * $sinTheta
            $Vertexs[$j].z = $z * $cosTheta + $x * $sinTheta
        }
    }

    if (ASKS("Q")) {
        #rotate around z axis
        for ($j = 0; $j -lt $Vertexs.Length; $j++) {
            $x = $Vertexs[$j].x
            $y = $Vertexs[$j].y
            $Vertexs[$j].x = $x * $cosTheta - $y * $sinTheta
            $Vertexs[$j].y = $x * $sinTheta + $y * $cosTheta
        }
    }

    if (ASKS("E")) {
        #rotate around z axis
        for ($j = 0; $j -lt $Vertexs.Length; $j++) {
            $x = $Vertexs[$j].x
            $y = $Vertexs[$j].y
            $Vertexs[$j].x = $x * $cosTheta + $y * $sinTheta
            $Vertexs[$j].y = $y * $cosTheta - $x * $sinTheta
        }
    }

    #scale 
    if (ASKS("Up")) {
        for ($j = 0; $j -lt $Vertexs.Length; $j++) {
            $Vertexs[$j].x *= 1.1
            $Vertexs[$j].y *= 1.1
            $Vertexs[$j].z *= 1.1
        }
    }

    if (ASKS("Down")) {
        for ($j = 0; $j -lt $Vertexs.Length; $j++) {
            $Vertexs[$j].x *= 0.9
            $Vertexs[$j].y *= 0.9
            $Vertexs[$j].z *= 0.9
        }
    }


    for ($t = 0; $t -lt $Faces.length; $t++) {
        $x1 = $Vertexs[$Faces[$t].v1].x
        $y1 = $Vertexs[$Faces[$t].v1].y
        $z1 = $Vertexs[$Faces[$t].v1].z
        $x2 = $Vertexs[$Faces[$t].v2].x
        $y2 = $Vertexs[$Faces[$t].v2].y
        $z2 = $Vertexs[$Faces[$t].v2].z
        $x3 = $Vertexs[$Faces[$t].v3].x
        $y3 = $Vertexs[$Faces[$t].v3].y
        $z3 = $Vertexs[$Faces[$t].v3].z
    
        $line1x = $x2 - $x1
        $line1y = $y2 - $y1
        $line1z = $z2 - $z1
        $line2x = $x3 - $x1
        $line2y = $y3 - $y1
        $line2z = $z3 - $z1

        $normalx = $line1y * $line2z - $line1z * $line2y
        $normaly = $line1z * $line2x - $line1x * $line2z
        $normalz = $line1x * $line2y - $line1y * $line2x

        $l = [math]::sqrt($normalx * $normalx + $normaly * $normaly + $normalz * $normalz)
        $normalx /= $l
        $normaly /= $l
        $normalz /= $l

        $dot = $normalx * ($x1 - $vCamera.x) + 
        $normaly * ($y1 - $vCamera.y) + 
        $normalz * ($z1 - $vCamera.z) 

        if ($dot -lt 0) {

            $lightVector = [math]::Sqrt(($lightPosition.X - $x1) * ($lightPosition.X - $x1) + ($lightPosition.Y - $y1) * ($lightPosition.Y - $y1) + ($lightPosition.Z - $z1) * ($lightPosition.Z - $z1))
            $objectNormal = [math]::Sqrt($x1 * $x1 + $y1 * $y1 + $z1 * $z1)
            $cosAngle = ($lightVector * $lightVector + $objectNormal * $objectNormal - $lightVector * $objectNormal) / (2 * $lightVector * $objectNormal)
            $shading = [Math]::Max(0, [Math]::Min(([Math]::Round(($cosAngle / $lightIntensity) * ($ShadeIndex.Length - 1))), $ShadeIndex.Length - 1))
            [char]$shade = $ShadeIndex[$shading]

            $x1 = ($x1 * ($distance / ($distance + $z1)))
            $y1 = ($y1 * ($distance / ($distance + $z1))) / 2
            $x2 = ($x2 * ($distance / ($distance + $z2)))
            $y2 = ($y2 * ($distance / ($distance + $z2))) / 2
            $x3 = ($x3 * ($distance / ($distance + $z3)))
            $y3 = ($y3 * ($distance / ($distance + $z3))) / 2

            $x1 = [math]::round($x1 + $nScreenWidth / 2)
            $y1 = [math]::round($y1 + $nScreenHeight / 2)
            $x2 = [math]::round($x2 + $nScreenWidth / 2)
            $y2 = [math]::round($y2 + $nScreenHeight / 2) 
            $x3 = [math]::round($x3 + $nScreenWidth / 2)
            $y3 = [math]::round($y3 + $nScreenHeight / 2)   
            if ($y2 -lt $y1) {
                [double] $tempX = $x1
                [double] $tempY = $y1
                $x1 = $x2
                $y1 = $y2
                $x2 = $tempX
                $y2 = $tempY
            }
            if ($y3 -lt $y1) {
                [double] $tempX = $x1
                [double] $tempY = $y1
                $x1 = $x3
                $y1 = $y3
                $x3 = $tempX
                $y3 = $tempY
            }
            if ($y3 -lt $y2) {
                [double] $tempX = $x2
                [double] $tempY = $y2
                $x2 = $x3
                $y2 = $y3
                $x3 = $tempX
                $y3 = $tempY
            }

            # Get the slope of the edges
            [double] $slope1 = ($x2 - $x1) / ($y2 - $y1)
            [double] $slope2 = ($x3 - $x1) / ($y3 - $y1)
            [double] $slope3 = ($x3 - $x2) / ($y3 - $y2)

            # Write the coordinates of the triangle
            for ([double] $scanlineY = $y1; $scanlineY -le $y2; $scanlineY += 1) {
                [double] $startX = $x1 + ($scanlineY - $y1) * $slope1
                [double] $endX = $x1 + ($scanlineY - $y1) * $slope2
                if ($startX -gt $endX) {
                    [double] $tempX = $startX
                    $startX = $endX
                    $endX = $tempX
                }
                for ([double] $scanlineX = $startX; $scanlineX -le $endX; $scanlineX += 1) {
                    if ($scanlineX -lt $nScreenWidth -and $scanlineY -lt $nScreenHeight -and $scanlineX -gt 0 -and $scanlineY -gt 0) { $screen[$scanlineY] = $screen[$scanlineY].Remove($scanlineX, 1); $screen[$scanlineY] = $screen[$scanlineY].Insert($scanlineX, $shade) }
                }
            }
            for ([double] $scanlineY = $y2; $scanlineY -le $y3; $scanlineY += 1) {
                [double] $startX = $x2 + ($scanlineY - $y2) * $slope3
                [double] $endX = $x1 + ($scanlineY - $y1) * $slope2
                if ($startX -gt $endX) {
                    [double] $tempX = $startX
                    $startX = $endX
                    $endX = $tempX
                }
                for ([double] $scanlineX = $startX; $scanlineX -le $endX; $scanlineX += 1) {
                    if ($scanlineX -lt $nScreenWidth -and $scanlineY -lt $nScreenHeight -and $scanlineX -gt 0 -and $scanlineY -gt 0) { $screen[$scanlineY] = $screen[$scanlineY].Remove($scanlineX, 1); $screen[$scanlineY] = $screen[$scanlineY].Insert($scanlineX, $shade) }
                }
            }   
        }
    }



    $sw.Stop()
    $fps = [math]::Round(10000000 / $sw.ElapsedTicks)
    [system.console]::title = "Made by: Jh1sc - FPS: $fps"
    [console]::setcursorposition(0, 0)
    [console]::write([string]::Join("`n", $screen))
}