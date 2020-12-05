<?xml version="1.0" encoding="UTF-8"?>
<ui version="4.0">
 <class>AudioRecorder</class>
 <widget class="QDialog" name="AudioRecorder">
  <property name="geometry">
   <rect>
    <x>0</x>
    <y>0</y>
    <width>418</width>
    <height>176</height>
   </rect>
  </property>
  <property name="windowTitle">
   <string>Dialog</string>
  </property>
  <widget class="QPushButton" name="outputButton">
   <property name="geometry">
    <rect>
     <x>30</x>
     <y>110</y>
     <width>93</width>
     <height>28</height>
    </rect>
   </property>
   <property name="text">
    <string>Output</string>
   </property>
  </widget>
  <widget class="QPushButton" name="recordButton">
   <property name="geometry">
    <rect>
     <x>150</x>
     <y>110</y>
     <width>93</width>
     <height>28</height>
    </rect>
   </property>
   <property name="text">
    <string>Record</string>
   </property>
  </widget>
  <widget class="QPushButton" name="pauseButton">
   <property name="geometry">
    <rect>
     <x>270</x>
     <y>110</y>
     <width>93</width>
     <height>28</height>
    </rect>
   </property>
   <property name="text">
    <string>Pause</string>
   </property>
  </widget>
  <widget class="QComboBox" name="audioDeviceBox">
   <property name="geometry">
    <rect>
     <x>150</x>
     <y>50</y>
     <width>111</width>
     <height>22</height>
    </rect>
   </property>
  </widget>
  <widget class="QLabel" name="label">
   <property name="geometry">
    <rect>
     <x>50</x>
     <y>50</y>
     <width>81</width>
     <height>21</height>
    </rect>
   </property>
   <property name="text">
    <string>Input:</string>
   </property>
  </widget>
  <widget class="QLabel" name="statusbar">
   <property name="geometry">
    <rect>
     <x>30</x>
     <y>150</y>
     <width>55</width>
     <height>16</height>
    </rect>
   </property>
   <property name="text">
    <string/>
   </property>
  </widget>
 </widget>
 <resources/>
 <connections/>
</ui>
