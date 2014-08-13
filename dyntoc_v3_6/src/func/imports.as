import com.panellayout.PanelBorderSkin;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.FileReference;
import flash.utils.Timer;
import flash.xml.XMLDocument;

import flashx.textLayout.container.ContainerController;
import flashx.textLayout.conversion.ConversionType;
import flashx.textLayout.edit.EditManager;
import flashx.textLayout.edit.ISelectionManager;
import flashx.textLayout.edit.SelectionState;
import flashx.textLayout.elements.InlineGraphicElement;
import flashx.textLayout.elements.ParagraphElement;
import flashx.textLayout.elements.TextFlow;
import flashx.textLayout.events.CompositionCompleteEvent;
import flashx.textLayout.events.DamageEvent;
import flashx.textLayout.events.FlowOperationEvent;
import flashx.textLayout.events.SelectionEvent;
import flashx.textLayout.events.StatusChangeEvent;
import flashx.textLayout.events.UpdateCompleteEvent;
import flashx.textLayout.formats.Direction;
import flashx.textLayout.formats.TextLayoutFormat;
import flashx.undo.UndoManager;

import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLDecoder;
import mx.utils.ArrayUtil;

import spark.components.BorderContainer;
import spark.components.CheckBox;
import spark.components.Group;
import spark.components.HSlider;
import spark.components.Label;
import spark.core.SpriteVisualElement;
import spark.effects.Move;
import spark.filters.GlowFilter;

import vo.bubble;
import vo.chapter;
[Bindable]
public var s1:String = "";
[Bindable]
public var s2:String = "";
[Bindable]
public var s3:String = "";
[Bindable]
public var s4:String = "";
[Bindable]
public var s5:String = "";
[Bindable]
public var s6:String = "";
public var superBookName:String = "";
public var superBookId:String = "";

private var fileRef:FileReference;
public var tc:SpriteVisualElement;
public var currentChapterView:Number = -1;
//public var serverLocation:String = "markbieber.ca/dyntoc";
//public var serverLocation:String = "markbieber.ca/dyntoc";
//[Bindable]
//public var dataLoc:String = "http://173.181.82.48:82";
//[Bindable]
//public var dataLoc:String = "http://ualbertaprojects.info:82";
//[Bindable]
//public var dataLoc:String = "http://192.168.1.150:82";


public var serverLocation:String = "http://localhost/dyntoc_v3_5/bin-debug";

//public var serverLocation:String = "http://www.ualbertaprojects.info/dyntoc_v3_5";



//private const FILE_UPLOAD_URL:String = serverLocation + "/fileref/uploader.php";
public var lastFileName:String = "";
[Bindable]
public var lastFileUrl:String = "";
[Bindable]
public var mainArray:ArrayCollection = new ArrayCollection();
[Bindable]
public var userTagArray:ArrayCollection = new ArrayCollection();
[Bindable]
public var infoArraye:ArrayCollection = new ArrayCollection();
[Bindable]
public var textFlowArray:ArrayCollection = new ArrayCollection();
[Bindable]
public var chapterContents:ArrayCollection = new ArrayCollection();
[Bindable]
public var tagArray:ArrayCollection = new ArrayCollection();
[Bindable]
public var tagCollection:ArrayCollection = new ArrayCollection();
[Bindable]
public var graphData:ArrayCollection = new ArrayCollection();
public var warnTimer:Timer = new Timer(1750,0);
public var highlightTexto:String = "";
public var highlightOccur:Number = 1;
public var chapterMax:Number = -1;
public var needParsing:Boolean = false;
public var chapterMin:Number = 9999999999;
public var bubbleSearchOptions:ArrayCollection = new ArrayCollection();