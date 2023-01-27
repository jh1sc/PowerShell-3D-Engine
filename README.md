# PowerShell 3D Engine 💎
![G](https://github.com/jh1sc/PowerShell-3D-Engine/blob/main/Updated%20Engines/Exmpl/title.png)
- `title.obj`

![](https://img.shields.io/badge/3D_ENGINE-_Made_By_Jh1sc-blue?style=for-the-badge)

# Setup 🌋
![G](https://github.com/jh1sc/PowerShell-3D-Engine/blob/main/Updated%20Engines/Exmpl/settings.png)
- Make sure your display setting look like this otherwise it will not work properly.



# Description 📶
This 3D Ascii Graphics engine is a beast. 

## Drawing Polygons 🔺
It consists 2 options to render, PolyFill and PolyWireFrame, both self explanatory, PolyFill uses a method called scanline rasterization, it is very efficient, in terms of computing power. PolyWireFrame, use a line drawing technique called bresenham's line, It is slightly faster than the full filled triangle.

## Polygon illuminatation 🔦
The shading used in this script, calculates the shading of an object based on its position relative to a light source using the Phong Illumination Model. The script uses the dot product of the surface normal and the vector pointing to the light source to calculate the angle between them and then uses this angle to determine the shading of the object.

## Face Sorting 🔰
The script sorts faces based on their dot product with a given normal vector. The dot product is calculated using the vertex coordinates of each face, as well as the coordinates of a camera position. Specifically, the script is calculating the dot product of the normal vector of each face with the vector pointing from the camera position to the centroid of the face. The script then checks whether the dot product is less than 0 and if so, it sorts the face into a different category. This sorting method is called backface culling. Its a very scappy way to do it but it still works, and its very efficient.

## Controls 🎮
-    W - rotate around x axis(+)
-    S - rotate around x axis(-)
-    A - rotate around y axis(+)
-    D - rotate around y axis(-)
-    Q - rotate around z axis(+)
-    E - rotate around z axis(-)
-    UP arrow - Translate Modely(+)
-    DOWN arrow - Translate Modely(-)
-    LEFT arrow - Translate Modelx(+)
-    RIGHt arrow - Translate Modelx(-)
-    Z - scale(+)
-    X  - scale(-)
-    L - Load new Model
-    T - Toggle Render Settings



# Useful Sources ✅
- https://github.com/onelonecoder | https://www.youtube.com/channel/UC-yuWVUplUJZvieEligKBkA
- https://youtu.be/QMYfkOtYYlg
- https://www.youtube.com/@TheCodingTrain
- https://www.youtube.com/watch?v=yMbQCKOULcU&t=180s
- https://youtu.be/p09i_hoFdd0
- https://youtu.be/IEbFwDv1RHU
- https://www.youtube.com/watch?v=X4QSm_p7Cy4


# How to create your own simple objs 💻
- First Create your model in 3d-Paint, make sure it is not over-complicated, remember we are working with powershell here
- Save it as a glb file, give it any name
- Go to this website (https://fabconvert.com/convert/glb/to/obj#google_vignette) and upload and download the obj file
- extract it from zip, then load it to the renderer!
- If You dont see you obj file, scale the model, its that simple!

![G](https://github.com/jh1sc/PowerShell-3D-Engine/blob/main/Updated%20Engines/Exmpl/Demonstration1.gif "Why U Lookin")
- `axis.obj`
