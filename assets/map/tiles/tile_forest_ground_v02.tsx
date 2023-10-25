<?xml version="1.0" encoding="UTF-8"?>
<tileset version="1.10" tiledversion="1.10.2" name="tile_forest_ground_v02" tilewidth="64" tileheight="64" tilecount="30" columns="6">
 <image source="tile_forest_ground_v02.png" width="384" height="320"/>
 <tile id="0" type="Platform"/>
 <tile id="1" type="Platform"/>
 <tile id="2" type="Platform"/>
 <tile id="3" type="Platform"/>
 <tile id="4" type="Platform"/>
 <tile id="5" type="Platform"/>
 <tile id="6" type="Platform">
  <objectgroup draworder="index" id="2">
   <object id="1" x="32" y="0" width="32" height="64"/>
  </objectgroup>
 </tile>
 <tile id="7" type="Slope">
  <properties>
   <property name="LeftTop" type="int" value="0"/>
   <property name="RightTop" type="int" value="64"/>
  </properties>
 </tile>
 <tile id="8" type="Platform"/>
 <tile id="9" type="Platform">
  <objectgroup draworder="index" id="2">
   <object id="1" x="39" y="0" width="25" height="39"/>
  </objectgroup>
 </tile>
 <tile id="10" type="Platform"/>
 <tile id="12">
  <objectgroup draworder="index" id="2">
   <object id="1" x="32" y="0" width="32" height="64"/>
  </objectgroup>
 </tile>
 <tile id="13" type="Slope">
  <properties>
   <property name="LeftTop" type="int" value="0"/>
   <property name="RightTop" type="int" value="52"/>
  </properties>
 </tile>
 <tile id="14" type="Slope">
  <properties>
   <property name="LeftTop" type="int" value="52"/>
   <property name="RightTop" type="int" value="64"/>
  </properties>
 </tile>
 <tile id="15" type="Platform"/>
 <tile id="18" type="Slope">
  <properties>
   <property name="LeftTop" type="int" value="0"/>
   <property name="RightTop" type="int" value="64"/>
  </properties>
 </tile>
 <tile id="19" type="Hazard"/>
 <tile id="21" type="Platform">
  <objectgroup draworder="index" id="2">
   <object id="1" x="27" y="0" width="37" height="64"/>
  </objectgroup>
 </tile>
 <tile id="22" type="Platform"/>
</tileset>
