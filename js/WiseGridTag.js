function initWiseGrid(objName, width, height)
{
  var WISEGRID_TAG = "<OBJECT ID='" + objName + "' codebase='/cab/WiseGrid/WiseGrid_v5_3_1_7.cab#version=5,3,1,7'";
  WISEGRID_TAG = WISEGRID_TAG + " NAME='" + objName + "' WIDTH=" + width + " HEIGHT=" + height + " border=0";
  WISEGRID_TAG = WISEGRID_TAG + " CLASSID='CLSID:E8AA1760-8BE5-4891-B433-C53F7333710F'>";
  WISEGRID_TAG = WISEGRID_TAG + " <PARAM NAME = 'strLicenseKeyList' VALUE='EEDE4E82078A984D664B46777C916778,B635B11EA938DD28C69C808A091EFFD9'>";
  WISEGRID_TAG = WISEGRID_TAG + "</OBJECT>";

  document.write(WISEGRID_TAG);
} 