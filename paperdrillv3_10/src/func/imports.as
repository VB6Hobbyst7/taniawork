// ActionScript file
import flash.events.*;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.*;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.SortField;
import mx.controls.*;
import mx.controls.ColorPicker;
import mx.effects.Glow;
import mx.events.*;
import mx.events.EffectEvent;
import mx.events.IndexChangedEvent;
import mx.events.ListEvent;
import mx.events.ToolTipEvent;
import mx.managers.*;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.states.*;

import spark.components.BorderContainer;
import spark.components.Label;
import spark.effects.Move;
import spark.effects.Scale;
import spark.events.IndexChangeEvent;
import spark.filters.GlowFilter;


public var lastViewedType:String = "";
public var lastCrumbAdded:String = "";
public var previousStats:String = "blank";
public var singleMode:Boolean = false;
public var goBongo:Boolean = false;
[Bindable]
public var author:String = "";
[Bindable]
public var book:String = "";
[Bindable]
public var cited:String = "";
[Bindable]
public var citedNum:uint = 0;
[Bindable]
public var date:uint = 2010;
private const _strUploadDomain:String = "http://codycodingcowboy.cahlan.com/";
private const _strUploadScript:String = _strUploadDomain + "files/upload.php";
private var _arrUploadFiles:Array = new Array();
private var _numCurrentUpload:Number = 0;
[Bindable]
public var seedID:uint = 0;
private var _refAddFiles:FileReferenceList;    
[Bindable]
public var seedAuthor:String = "";
[Bindable]
public var seedTitle:String = "";
[Bindable]
public var mainSeedAuthor:String = "";
[Bindable]
public var mainSeedTitle:String = "";
[Bindable]
public var seedPath:uint = 0;
private var _refUploadFile:FileReference;
[Bindable]
public var totalsendo:uint = 700;
[Bindable]
public var aChoice:ArrayCollection = new ArrayCollection();
[Bindable]
public var aChoice2:ArrayCollection = new ArrayCollection();
[Bindable]
public var fChoice:ArrayCollection = new ArrayCollection();
private var _winProgress:winProgress;

[Bindable]
public var collections:ArrayCollection = new ArrayCollection();
public var openRec:Boolean = false;
public var r1x:uint = 0;
public var r1y:uint = 0;
public var r2x:uint = 0;
public var r2y:uint = 0;
public var r3x:uint = 0;
public var r3y:uint = 0;
public var r4x:uint = 0;
public var r4y:uint = 0;
public var r5x:uint = 0;
public var r5y:uint = 0;
public var r6x:uint = 0;
public var phomeval1:uint = 0;
public var phomeval2:uint = 0;
public var r6y:uint = 0;
public var dateFiltVal1:uint = 0;
public var dateFiltVal2:uint = 0;
public var authorFiltVal1:String = "";
public var authorFiltVal2:String = "";
public var titleFiltVal1:String = "";
public var titleFiltVal2:String = "";
public var savedCollectIndex:uint = 0;
public var afterfirst:Boolean = false;
public var color:ColorPicker = new ColorPicker();
public var sortValX:uint = 0;
public var sortValY:uint = 0;
public var currentID:String = "";
[Bindable]
public var divisionX:uint = 5;
[Bindable]
public var divisionY:uint = 5;
[Bindable]
public var lastDivX:uint = 5;
[Bindable]
public var lastDivY:uint = 5;
public var rectArray:Array = new Array();
public var previousX:Number = 0;
public var previousY:Number = 0;
public var previousIndex:Number = 0;
public var homeSquareArray:ArrayCollection = new ArrayCollection();
public var heatColor:Boolean = true;
public var searchTexto:String = "";
public var docOpen:Boolean = false;
[Bindable]
public var startSeedo:ArrayCollection = new ArrayCollection();
[Bindable]
public var labelArrayX:ArrayCollection = new ArrayCollection();
[Bindable]
public var labelArrayY:ArrayCollection = new ArrayCollection();
public var rectOpen:Boolean = false;
public var ti:Timer = new Timer(1000,0);
public var seedCitations:ArrayCollection = new ArrayCollection();
[Bindable]
public var iddo:uint = 0;
public var citedX:uint = 0;
public var citedY:uint = 0;
public var citingX:uint = 0;
public var citingY:uint = 0;
public var citingArray:ArrayCollection = new ArrayCollection();
public var citedArray:ArrayCollection = new ArrayCollection();
public var citationViewVal:uint = 1;//by default set to textMode;
public var citationWaterMode:uint = 1;//1 = both, 2 = cited, 3 = citing;
