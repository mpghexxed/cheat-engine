unit MainUnit;

{$MODE Delphi}

interface

uses
  jwaWindows, Windows, LCLIntf, LCLProc, Messages, SysUtils, Classes, Graphics,
  Controls, Forms, ComCtrls, StdCtrls, Menus, CEFuncproc, Buttons, shellapi,
  imagehlp, ExtCtrls, Dialogs, Clipbrd, CEDebugger, kerneldebugger, assemblerunit,
  hotkeyhandler, registry, Math, ImgList, commctrl, NewKernelHandler,
  unrandomizer, symbolhandler, ActnList, LResources, hypermode, memscan,
  autoassembler, plugin, savefirstscan, menuitemExtra, speedhack2, AccessCheck,
  foundlisthelper, disassembler, peinfounit, PEInfoFunctions,
  simpleaobscanner, pointervaluelist, ManualModuleLoader, debughelper,
  frmRegistersunit, ctypes, addresslist, addresslisthandlerunit, memoryrecordunit,
  windows7taskbar, tablist, DebuggerInterface, vehdebugger, tableconverter,
  customtypehandler, lua, luahandler, lauxlib, lualib, frmSelectionlistunit,
  htmlhelp, win32int, {defaulttranslator,} fileaccess, formdesignerunit,
  ceguicomponents, frmautoinjectunit, cesupport, trainergenerator, genericHotkey,
  luafile, xmplayer_server, sharedMemory{$ifdef windows}, win32proc{$endif},
  vmxfunctions, FileUtil, networkInterfaceApi, networkconfig, d3dhookUnit, PNGcomn,
  FPimage, byteinterpreter, frmgroupscanalgoritmgeneratorunit, vartypestrings,
  groupscancommandparser, GraphType, IntfGraphics, RemoteMemoryManager,
  DBK64SecondaryLoader, savedscanhandler, debuggertypedefinitions, networkInterface,
  FrmMemoryRecordDropdownSettingsUnit, xmlutils, zstream, zstreamext, commonTypeDefs,
  VirtualQueryExCache, LazLogger, LazUTF8, LCLVersion;

//the following are just for compatibility



const
  copypasteversion = 4;

const
  wm_freedebugger = WM_USER + 1;

const
  //wm_scandone = WM_USER + 2;
  wm_pluginsync = WM_USER + 3;

  wm_showerror = WM_USER + 4;

//scantabs
type
  TProcessOpenedEvent=procedure(processid: THandle; processhandle: DWORD; caption: string) of object;


  TScanState = record
    alignsizechangedbyuser: boolean;
    compareToSavedScan: boolean;
    currentlySelectedSavedResultname: string; //I love long variable names

    lblcompareToSavedScan: record
      Caption: string;
      Visible: boolean;
      left: integer;
    end;


    FromAddress: record
      Text: string;
    end;

    ToAddress: record
      Text: string;
    end;

    cbReadOnly: record
      Checked: boolean;
    end;

    cbfastscan: record
      Checked: boolean;
    end;

    cbunicode: record
      checked: boolean;
      visible: boolean;
    end;

    cbcodepage: record
      checked: boolean;
      visible: boolean;
    end;

    cbCaseSensitive: record
      checked: boolean;
      visible: boolean;
    end;

    edtAlignment: record
      Text: string;
      Enabled: boolean;
    end;

    rbFsmAligned:record
      checked: boolean;
    end;


    cbpercentage: record
      exists: boolean;
      Checked: boolean;
    end;


    floatpanel: record
      Visible: boolean;
      rounded: boolean;
      roundedextreme: boolean;
      truncated: boolean;
    end;

    rbbit: record
      Visible: boolean;
      Enabled: boolean;
      Checked: boolean;
    end;

    rbdec: record
      Visible: boolean;
      Enabled: boolean;
      Checked: boolean;
    end;

    cbHexadecimal: record
      Visible: boolean;
      Checked: boolean;
      Enabled: boolean;
    end;

    gbScanOptionsEnabled: boolean;

    scantype: record
      options: string;
      ItemIndex: integer;
      Enabled: boolean;
      dropdowncount: integer;
    end;

    vartype: record
      //options: TStringList;
      ItemIndex: integer;
      Enabled: boolean;
    end;


    memscan: TMemscan;
    foundlist: TFoundList;


    scanvalue: record
      Visible: boolean;
      Text: string;
    end;

    scanvalue2: record
      exists: boolean;
      Text: string;
    end;

    firstscanstate: record
      Caption: string;
      Enabled: boolean;
    end;

    nextscanstate: record
      Enabled: boolean;
    end;

    btnFirst: record
      tag: integer;
    end;

    foundlist3: record
      ItemIndex: integer;
    end;
    foundlistDisplayOverride: integer;


    cbNot:record
      Checked: boolean;
    end;

    cbfloatSimple: record
      Checked: boolean;
    end;

  end;
  PScanState = ^TScanState;


type
  TFlash = class(TThread)
  public
    procedure Execute; override;
    procedure col;
  end;


type
  TToggleWindows = class(TThread)
  private
  public
    constructor Create(CreateSuspended: boolean);
    procedure Execute; override;
  end;

type
  TAutoAttachThread=class(TThread)
  private
    fInterval: integer;
  public
    CurrentProcessList: TStringList;
    procedure autoattachcheck;
    constructor Create(CreateSuspended: boolean);
    procedure Execute; override;
  published
    property Interval: integer read fInterval write fInterval;
  end;



type
  grouptype = array[1..6] of boolean;


type

  { TMainForm }

  TMainForm = class(TForm)
    actOpenLuaEngine: TAction;
    actOpenDissectStructure: TAction;
    btnSetSpeedhack2: TButton;
    btnAddAddressManually: TButton;
    btnMemoryView: TButton;
    cbCaseSensitive: TCheckBox;
    cbCopyOnWrite: TCheckBox;
    cbExecutable: TCheckBox;
    cbFastScan: TCheckBox;
    cbFloatSimple: TCheckBox;
    cbHexadecimal: TCheckBox;
    cbPauseWhileScanning: TCheckBox;
    cbSpeedhack: TCheckBox;
    cbUnicode: TCheckBox;
    cbUnrandomizer: TCheckBox;
    cbWritable: TCheckBox;
    cbpercentage: TCheckBox;
    cbNot: TCheckBox;
    cbCodePage: TCheckBox;
    ColorDialog1: TColorDialog;
    CreateGroup: TMenuItem;
    FromAddress: TEdit;
    andlabel: TLabel;
    mfImageList: TImageList;
    lblSigned: TLabel;
    MainMenu2: TMainMenu;
    MenuItem12: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    Copyselectedaddresses1: TMenuItem;
    miAutoAssembleErrorMessage: TMenuItem;
    miLuaDocumentation: TMenuItem;
    miForgotScan: TMenuItem;
    miDotNET: TMenuItem;
    miGetDotNetObjectList: TMenuItem;
    miDBVMFindWhatWritesOrAccesses: TMenuItem;
    sep2: TMenuItem;
    miChangeValueBack: TMenuItem;
    miSignTable: TMenuItem;
    miSaveFile: TMenuItem;
    miAsyncScript: TMenuItem;
    miFlFindWhatAccesses: TMenuItem;
    MenuItem13: TMenuItem;
    miFlFindWhatWrites: TMenuItem;
    miLanguages: TMenuItem;
    ScanText2: TLabel;
    scanvalue2: TEdit;
    tLuaGCPassive: TTimer;
    tLuaGCActive: TTimer;
    ToAddress: TEdit;
    editSH2: TEdit;
    edtAlignment: TEdit;
    Foundlist3: TListView;
    ImageList2: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label54: TLabel;
    lblcompareToSavedScan: TLabel;
    lblSH0: TLabel;
    lblSH20: TLabel;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    miEnableLCLDebug: TMenuItem;
    miDisassemble: TMenuItem;
    miBindDeactivation: TMenuItem;
    miScanDirtyOnly: TMenuItem;
    miScanPagedOnly: TMenuItem;
    miGeneratePointermap: TMenuItem;
    miDisplayHex: TMenuItem;
    miNetwork: TMenuItem;
    miCompression: TMenuItem;
    miManualExpandCollapse: TMenuItem;
    miSetDropdownOptions: TMenuItem;
    miSave: TMenuItem;
    miSnapshothandler: TMenuItem;
    miSetupSnapshotKeys: TMenuItem;
    miDisplayDefault: TMenuItem;
    miDisplayByte: TMenuItem;
    miDisplay2Byte: TMenuItem;
    miDisplay4Byte: TMenuItem;
    miDisplayFloat: TMenuItem;
    miDisplayDouble: TMenuItem;
    miDisplay8Byte: TMenuItem;
    MenuItem19: TMenuItem;
    miShowPreviousValue: TMenuItem;
    MenuItem4: TMenuItem;
    miShowCustomTypeDebug: TMenuItem;
    miShowAsSigned: TMenuItem;
    miOpenFile: TMenuItem;
    MenuItem8: TMenuItem;
    miTutorial: TMenuItem;
    miLockMouseInGame: TMenuItem;
    miChangeValue: TMenuItem;
    miAddAddress: TMenuItem;
    miAllowCollapse: TMenuItem;
    miSetCrosshair: TMenuItem;
    miWireframe: TMenuItem;
    miZbuffer: TMenuItem;
    miHookD3D: TMenuItem;
    mi3d: TMenuItem;
    miUndoValue: TMenuItem;
    miPresetWritable: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    miShowLuaScript: TMenuItem;
    MenuItem5: TMenuItem;
    miPresetAll: TMenuItem;
    miAddFile: TMenuItem;
    MenuItem9: TMenuItem;
    miResyncFormsWithLua: TMenuItem;
    miCreateLuaForm: TMenuItem;
    miLuaFormsSeperator: TMenuItem;
    miTable: TMenuItem;
    miSaveScanresults: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    miShowAsBinary: TMenuItem;
    miZeroTerminate: TMenuItem;
    miResetRange: TMenuItem;
    miChangeColor: TMenuItem;
    miGroupconfig: TMenuItem;
    miDefineNewCustomTypeLua: TMenuItem;
    miDeleteCustomType: TMenuItem;
    miHideChildren: TMenuItem;
    miBindActivation: TMenuItem;
    miRecursiveSetValue: TMenuItem;
    miDefineNewCustomType: TMenuItem;
    miEditCustomType: TMenuItem;
    miRenameTab: TMenuItem;
    miTablistSeperator: TMenuItem;
    miCloseTab: TMenuItem;
    miAddTab: TMenuItem;
    miFreezePositive: TMenuItem;
    miFreezeNegative: TMenuItem;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel14: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    pnlFloat: TPanel;
    pnlScanOptions: TPanel;
    pnlScanValueOptions: TPanel;
    pmTablist: TPopupMenu;
    pmValueType: TPopupMenu;
    pmResetRange: TPopupMenu;
    pmScanRegion: TPopupMenu;
    rbBit: TRadioButton;
    rbDec: TRadioButton;
    rbFsmAligned: TRadioButton;
    rbfsmLastDigts: TRadioButton;
    rt1: TRadioButton;
    rt2: TRadioButton;
    rt3: TRadioButton;
    SettingsButton: TSpeedButton;
    tbSpeed: TTrackBar;
    UpdateTimer: TTimer;
    FreezeTimer: TTimer;
    PopupMenu2: TPopupMenu;
    Deletethisrecord1: TMenuItem;
    Browsethismemoryregion1: TMenuItem;
    Calculatenewvaluepart21: TMenuItem;
    Freezealladdresses2: TMenuItem;
    sep1: TMenuItem;
    N1: TMenuItem;
    N4: TMenuItem;
    Copy1: TMenuItem;
    Paste1: TMenuItem;
    Cut1: TMenuItem;
    Setbreakpoint1: TMenuItem;
    SetHotkey1: TMenuItem;
    N5: TMenuItem;
    Panel4: TPanel;
    advancedbutton: TSpeedButton;
    CommentButton: TSpeedButton;
    Panel5: TPanel;
    ProcessLabel: TLabel;
    foundcountlabel: TLabel;
    ScanText: TLabel;
    lblScanType: TLabel;
    lblValueType: TLabel;
    LoadButton: TSpeedButton;
    SaveButton: TSpeedButton;
    Label6: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    gbScanOptions: TGroupBox;
    btnNewScan: TButton;
    btnNextScan: TButton;
    ScanType: TComboBox;
    VarType: TComboBox;
    ProgressBar: TProgressBar;
    UndoScan: TButton;
    scanvalue: TEdit;
    foundlistpopup: TPopupMenu;
    Browsethismemoryarrea1: TMenuItem;
    Removeselectedaddresses1: TMenuItem;
    Selectallitems1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    TopDisabler: TTimer;
    emptypopup: TPopupMenu;
    ccpmenu: TPopupMenu;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Paste2: TMenuItem;
    Splitter1: TSplitter;
    Findoutwhataccessesthisaddress1: TMenuItem;
    Showashexadecimal1: TMenuItem;
    Panel7: TPanel;
    sbOpenProcess: TSpeedButton;
    Change1: TMenuItem;
    Description1: TMenuItem;
    Address1: TMenuItem;
    Type1: TMenuItem;
    Value1: TMenuItem;
    Changescript1: TMenuItem;
    ActionList1: TActionList;
    actSave: TAction;
    actOpen: TAction;
    actAutoAssemble: TAction;
    Forcerechecksymbols1: TMenuItem;
    Smarteditaddresses1: TMenuItem;
    Pointerscanforthisaddress1: TMenuItem;
    Plugins1: TMenuItem;
    UpdateFoundlisttimer: TTimer;
    Browsethismemoryregioninthedisassembler1: TMenuItem;
    AutoAttachTimer: TTimer;
    btnFirst: TButton;
    btnNext: TButton;
    LogoPanel: TPanel;
    Logo: TImage;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Process1: TMenuItem;
    miHelp: TMenuItem;
    Edit3: TMenuItem;
    miAbout: TMenuItem;
    OpenProcess1: TMenuItem;
    Save1: TMenuItem;
    Load1: TMenuItem;
    Settings1: TMenuItem;
    N6: TMenuItem;
    a1: TMenuItem;
    b1: TMenuItem;
    c1: TMenuItem;
    d1: TMenuItem;
    e1: TMenuItem;
    CreateProcess1: TMenuItem;
    New1: TMenuItem;
    N7: TMenuItem;
    ools1: TMenuItem;
    N8: TMenuItem;
    Helpindex1: TMenuItem;
    Plugins2: TMenuItem;
    actMemoryView: TAction;
    actOpenProcesslist: TAction;
    procedure actOpenDissectStructureExecute(Sender: TObject);
    procedure actOpenLuaEngineExecute(Sender: TObject);
    procedure Address1Click(Sender: TObject);
    procedure cbPercentageOnChange(Sender: TObject);
    procedure cbCodePageChange(Sender: TObject);
    procedure cbUnicodeChange(Sender: TObject);
    procedure Copyselectedaddresses1Click(Sender: TObject);
    procedure EnableLCLClick(Sender: TObject);
    procedure cbFastScanChange(Sender: TObject);
    procedure cbUnrandomizerChange(Sender: TObject);
    procedure Description1Click(Sender: TObject);
    procedure edtAlignmentKeyPress(Sender: TObject; var Key: char);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure Foundlist3CustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: boolean);
    procedure Foundlist3CustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure CreateGroupClick(Sender: TObject);
    procedure Foundlist3SelectItem(Sender: TObject; Item: TListItem;
      Selected: boolean);
    procedure Label3Click(Sender: TObject);
    procedure MenuItem12Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure miAutoAssembleErrorMessageClick(Sender: TObject);
    procedure miHelpClick(Sender: TObject);
    procedure miLuaDocumentationClick(Sender: TObject);
    procedure miForgotScanClick(Sender: TObject);
    procedure miGetDotNetObjectListClick(Sender: TObject);
    procedure miChangeValueBackClick(Sender: TObject);
    procedure miDBVMFindWhatWritesOrAccessesClick(Sender: TObject);
    procedure miSignTableClick(Sender: TObject);
    procedure miAsyncScriptClick(Sender: TObject);
    procedure miFlFindWhatAccessesClick(Sender: TObject);
    procedure miBindDeactivationClick(Sender: TObject);
    procedure miDisassembleClick(Sender: TObject);
    procedure miFlFindWhatWritesClick(Sender: TObject);
    procedure miSaveFileClick(Sender: TObject);
    procedure miScanDirtyOnlyClick(Sender: TObject);
    procedure miCompressionClick(Sender: TObject);
    procedure miGeneratePointermapClick(Sender: TObject);
    procedure miManualExpandCollapseClick(Sender: TObject);
    procedure miSaveClick(Sender: TObject);
    procedure mi3dClick(Sender: TObject);
    procedure miChangeDisplayTypeClick(Sender: TObject);
    procedure miOpenFileClick(Sender: TObject);
    procedure miScanPagedOnlyClick(Sender: TObject);
    procedure miSetDropdownOptionsClick(Sender: TObject);
    procedure miShowAsSignedClick(Sender: TObject);
    procedure miShowCustomTypeDebugClick(Sender: TObject);
    procedure miShowPreviousValueClick(Sender: TObject);
    procedure miSnapshothandlerClick(Sender: TObject);
    procedure miTutorialClick(Sender: TObject);
    procedure miChangeValueClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure miShowLuaScriptClick(Sender: TObject);
    procedure miAddAddressClick(Sender: TObject);
    procedure miAllowCollapseClick(Sender: TObject);
    procedure miHookD3DClick(Sender: TObject);
    procedure miLockMouseInGameClick(Sender: TObject);
    procedure miPresetAllClick(Sender: TObject);
    procedure miAddFileClick(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure miPresetWritableClick(Sender: TObject);
    procedure miResyncFormsWithLuaClick(Sender: TObject);
    procedure miCreateLuaFormClick(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure miSetCrosshairClick(Sender: TObject);
    procedure miTableClick(Sender: TObject);
    procedure miResetRangeClick(Sender: TObject);
    procedure miChangeColorClick(Sender: TObject);
    procedure miDefineNewCustomTypeLuaClick(Sender: TObject);
    procedure miDeleteCustomTypeClick(Sender: TObject);
    procedure miBindActivationClick(Sender: TObject);
    procedure miEditCustomTypeClick(Sender: TObject);
    procedure miHideChildrenClick(Sender: TObject);
    procedure miDefineNewCustomTypeClick(Sender: TObject);
    procedure miRecursiveSetValueClick(Sender: TObject);
    procedure miRenameTabClick(Sender: TObject);
    procedure miAddTabClick(Sender: TObject);
    procedure miCloseTabClick(Sender: TObject);
    procedure miFreezeNegativeClick(Sender: TObject);
    procedure miFreezePositiveClick(Sender: TObject);
    procedure miSaveScanresultsClick(Sender: TObject);
    procedure miShowAsBinaryClick(Sender: TObject);
    procedure miUndoValueClick(Sender: TObject);
    procedure miWireframeClick(Sender: TObject);
    procedure miZbufferClick(Sender: TObject);
    procedure miZeroTerminateClick(Sender: TObject);
    procedure ools1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel5Resize(Sender: TObject);
    procedure pmTablistPopup(Sender: TObject);
    procedure pmValueTypePopup(Sender: TObject);
    procedure rbAllMemoryChange(Sender: TObject);
    procedure rbFsmAlignedChange(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure ShowProcessListButtonClick(Sender: TObject);
    procedure btnNewScanClick(Sender: TObject);
    procedure btnNextScanClick(Sender: TObject);
    procedure btnMemoryViewClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure AddressKeyPress(Sender: TObject; var Key: char);
    procedure FoundListDblClick(Sender: TObject);
    procedure Browsethismemoryarrea1Click(Sender: TObject);
    procedure tLuaGCActiveTimer(Sender: TObject);
    procedure tLuaGCPassiveTimer(Sender: TObject);
    procedure UpdateTimerTimer(Sender: TObject);
    procedure FreezeTimerTimer(Sender: TObject);
    procedure Browsethismemoryregion1Click(Sender: TObject);
    procedure Deletethisrecord1Click(Sender: TObject);
    procedure ScanvalueoldKeyPress(Sender: TObject; var Key: char);
    procedure Calculatenewvaluepart21Click(Sender: TObject);
    procedure btnAddAddressManuallyClick(Sender: TObject);
    procedure ScanTypeChange(Sender: TObject);
    procedure Value1Click(Sender: TObject);
    procedure VarTypeChange(Sender: TObject);
    procedure LogoClick(Sender: TObject);
    procedure VarTypeDropDown(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure Selectallitems1Click(Sender: TObject);
    procedure Freezealladdresses2Click(Sender: TObject);
    procedure PopupMenu2Popup(Sender: TObject);
    procedure foundlistpopupPopup(Sender: TObject);
    procedure Removeselectedaddresses1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CommentButtonClick(Sender: TObject);
    procedure CommentButtonMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure Copy1Click(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Setbreakpoint1Click(Sender: TObject);
    procedure TopDisablerTimer(Sender: TObject);
    procedure advancedbuttonClick(Sender: TObject);
    procedure cbHexadecimalClick(Sender: TObject);
    procedure SetHotkey1Click(Sender: TObject);
    procedure UndoScanClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbBitClick(Sender: TObject);
    procedure rbDecClick(Sender: TObject);
    procedure Cut2Click(Sender: TObject);
    procedure Copy2Click(Sender: TObject);
    procedure Paste2Click(Sender: TObject);
    procedure ccpmenuPopup(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: integer;
      var Accept: boolean);
    procedure Splitter1Moved(Sender: TObject);
    procedure SettingsClick(Sender: TObject);
    procedure cbCaseSensitiveClick(Sender: TObject);
    procedure LogoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure Findoutwhataccessesthisaddress1Click(Sender: TObject);
    procedure OpenProcesslist1Click(Sender: TObject);
    procedure CloseCheatEngine1Click(Sender: TObject);
    procedure Showashexadecimal1Click(Sender: TObject);
    procedure OpenMemorybrowser1Click(Sender: TObject);
    procedure cbPauseWhileScanningClick(Sender: TObject);
    procedure ProcessLabelDblClick(Sender: TObject);
    procedure ProcessLabelMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure cbUnrandomizerClick(Sender: TObject);
    procedure cbUnrandomizerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: integer);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actAutoAssembleExecute(Sender: TObject);
    procedure Changescript1Click(Sender: TObject);
    procedure Forcerechecksymbols1Click(Sender: TObject);
    procedure Smarteditaddresses1Click(Sender: TObject);
    procedure Pointerscanforthisaddress1Click(Sender: TObject);
    procedure Label53Click(Sender: TObject);
    procedure Foundlist3Data(Sender: TObject; Item: TListItem);
    procedure UpdateFoundlisttimerTimer(Sender: TObject);
    procedure Foundlist3KeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure Browsethismemoryregioninthedisassembler1Click(Sender: TObject);
    procedure AutoAttachTimerTimer(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tbSpeedChange(Sender: TObject);
    procedure btnSetSpeedhack2Click(Sender: TObject);
    procedure cbSpeedhackChange(Sender: TObject);
    procedure Process1Click(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure CreateProcess1Click(Sender: TObject);
    procedure Helpindex1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure actOpenProcesslistExecute(Sender: TObject);
    procedure Type1Click(Sender: TObject);
  private
    onetimeonly: boolean; //to protect against make mainform visible (.show)

    scantimestart, scantimefinish: int64;

    tabcounter: integer;
    //variable that only goes up, doesn't go down when a tab is deleted
    scantablist: TTablist;

    oldscanvalue2text: string;
    aaa: single;
    hotkeypressed: integer;

    cancelbutton: TButton;
    //cancel button that spawns during a scan, disabled initially to prevent doubleclick accidents
    cancelbuttonenabler: TTimer;
    //timer that will enable the cancelbutton after 3 seconds

    groupconfigbutton: TButton;

    oldwidth, oldheight: integer;
    newaddress: ptrUint;
    isbit: boolean;
    tempbitmap: Tbitmap;
    dontrunshow: boolean;

    LastWasHex: boolean;
    dontconvert: boolean;
    FlashProcessButton: TFlash;
    oldvartype: integer;

    unrandomize: Tunrandomize;



    reinterpretcheck: integer;

    ffoundcount: int64;
    foundlistDisplayOverride: integer; //a number specifying what type to display (0=default)

    SaveFirstScanThread: TSaveFirstScanThread;

    foundlist: Tfoundlist;
    PreviousResults: TSavedScanHandler;
    lastscantype: integer;

    oldhandle: thandle;

    compareToSavedScan: boolean;
    currentlySelectedSavedResultname: string; //I love long variable names

    alignsizechangedbyuser: boolean;
    scantypechangedbyhotkey: boolean;

    fIsProtected: boolean;
    fOnProcessOpened: TProcessOpenedEvent;

    overlayid: integer;   //debug
    lastAdded: record
      Address: string;
      vartype: TVariableType;
    end;


    saveGotCanceled: boolean; //set to true if the last save button click was canceled

    UserDefinedTableName: string; //set when a user opens a table (when set the filename prediction will be turned off)

    speedhackDisableTimer: TTimer;
    procedure CheckForSpeedhackKey(sender: TObject);

    procedure doNewScan;
    procedure SetExpectedTableName;

    procedure aprilfoolsscan;
    function CheckIfSaved: boolean;
    procedure checkpaste;
    procedure hotkey(var Message: TMessage); message WM_HOTKEY;
    procedure Hotkey2(var Message: TMessage); message wm_hotkey2;
    procedure ScanDone(sender: TObject); //(var message: TMessage); message WM_SCANDONE;
    procedure PluginSync(var m: TMessage); message wm_pluginsync;
    procedure ShowError(var message: TMessage); message wm_showerror;
    procedure Edit;
    procedure paste(simplecopypaste: boolean);
    procedure CopySelectedRecords;


    procedure exceptionhandler(Sender: TObject; E: Exception);
    procedure toggleWindow;
    procedure adjustbringtofronttext;

    procedure scanEpilogue(canceled: boolean);
    procedure CancelbuttonClick(Sender: TObject);
    procedure CancelbuttonenablerInterval(Sender: TObject);

    procedure changeScriptCallback(memrec: TMemoryRecord; script: string;
      changed: boolean);

    //processlist
    procedure ProcessItemClick(Sender: TObject);

    //property functions
    function GetRoundingType: TRoundingType;
    procedure SetRoundingType(rt: TRoundingType);
    function getScanStart: ptruint;
    procedure setScanStart(newscanstart: ptruint);
    function getScanStop: ptruint;
    procedure setScanStop(newscanstop: ptruint);
    function getFastscan: boolean;
    procedure setFastScan(state: boolean);

    function getSelectedVariableType: TVariableType;
    procedure setfoundcount(x: int64);


    procedure AddresslistDropByListview(Sender: TObject; node: TTreenode;
      attachmode: TNodeAttachMode);

    procedure SaveCurrentState(scanstate: PScanState; skipuservalues: boolean=false);
    procedure SetupInitialScanTabState(scanstate: PScanState; IsFirstEntry: boolean);
    procedure ScanTabListTabChange(Sender: TObject; oldselection: integer);

    procedure UpdateFloatRelatedPositions;

    //custom type:
    procedure CreateCustomType(customtype: TCustomtype; script: string;
      changed: boolean; lua: boolean = False);


    procedure LoadCustomTypesFromRegistry;

    procedure setGbScanOptionsEnabled(state: boolean);
    procedure cbSaferPhysicalMemoryChange(sender: tobject);


    function onhelp(Command: word; Data: PtrInt; var CallHelp: boolean): boolean;
    procedure SaveIntialTablesDir(dir: string);

    function convertvalue(ovartype, nvartype: integer; oldvalue: string;
      washexadecimal, ishexadecimal: boolean): string;

    //designer functions
    procedure RenameFileClick(Sender: TObject);
    procedure SaveFileClick(Sender: TObject);
    procedure DeleteFileClick(Sender: TObject);

    procedure EditFormClick(Sender: TObject);
    procedure RestoreAndShowFormClick(Sender: TObject);
    procedure DeleteFormClick(Sender: TObject);
    procedure FormDesignerClose(Sender: TObject; var CloseAction: TCloseAction);

    procedure setIsProtected(p: boolean);

    procedure d3dclicktest(overlayid: integer; x, y: integer);


    procedure createGroupConfigButton;
    procedure destroyGroupConfigButton;

    procedure MemscanGuiUpdate(sender: TObject; totaladdressestoscan: qword; currentlyscanned: qword; foundcount: qword);

  public
    { Public declarations }
    addresslist: TAddresslist;

    //test: single;
    itemshavechanged: boolean;

    debugproc: boolean;
    autoopen: boolean;
    //boolean set when table is opened by other means than user file picker

    Priority: Dword;
    memimage: TMemorystream;

    canceled: boolean;

    originalheight: integer;
    originalwidth: integer;

    fronttext: string;


    aprilfools: boolean;
    editedsincelastsave: boolean;

    autoattachlist: TStringList;
    extraautoattachlist: TStringList;
    //modifed by plugins and scripts, not affected by settings changes
    oldcodelistcount: integer;

    memscan: tmemscan;
    LuaForms: TList;
    LuaFiles: TLuaFileList;
    InternalLuaFiles: TLuaFileList;
    frmLuaTableScript: Tfrmautoinject;


    cbsaferPhysicalMemory: TCheckbox;
    mustClose: boolean;

    imgSignature: TImage;


    procedure updated3dgui;
    procedure RefreshCustomTypes;

    procedure autoattachcheck(pl: TStringList = nil); // can be called by AutoAttachTimer or AutoAttachThread
    function openprocessPrologue: boolean;
    procedure openProcessEpilogue(oldprocessname: string; oldprocess: dword;
      oldprocesshandle: dword; autoattachopen: boolean = False);


    procedure ChangedHandle(Sender: TObject);
    procedure plugintype0click(Sender: TObject);
    procedure plugintype5click(Sender: TObject);
    procedure OnToolsClick(Sender: TObject);
    procedure AddToRecord(Line: integer; node: TTreenode = nil;
      attachmode: TNodeAttachMode = naAdd);
    procedure AddAutoAssembleScript(script: string);
    procedure reinterpretaddresses;


    procedure ClearList;

    procedure CreateScanValue2;
    procedure DestroyScanValue2;


    procedure CreateCbPercentage;
    procedure DestroyCbPercentage;

    procedure UpdateScanType;
    procedure enableGui(isnextscan: boolean);
    procedure disableGui;
    procedure SpawnCancelButton;
    procedure DestroyCancelButton;

    procedure AddressListAutoAssemblerEdit(Sender: TObject; memrec: TMemoryRecord);
    procedure createFormdesigner;
    procedure UpdateMenu;

    procedure DoGroupconfigButtonClick(sender: tobject);

    function getVarType: TVariableType;
    function getVarType2: TVariableType;
    procedure setVarType(vt: TVariableType);

    function GetScanType: TScanOption;
    function GetScanType2: TScanOption;


    property foundcount: int64 read ffoundcount write setfoundcount;
    property RoundingType: TRoundingType read GetRoundingType write SetRoundingType;
    property ScanStart: ptruint read getScanStart write setScanStart;
    property ScanStop: ptruint read getScanStop write setScanStop;
    property FastScan: boolean read getFastscan write setFastscan;


    property SelectedVariableType: TVariableType read getSelectedVariableType;
    property isProtected: boolean read fIsProtected write setIsProtected;
  published
    property Progressbar1: TProgressBar read Progressbar write ProgressBar;
    property About1: TMenuItem read miAbout write miAbout;
    property Help1: TMenuItem read miHelp write miHelp;
    property OnProcessOpened: TProcessOpenedEvent read fOnProcessOpened write fOnProcessOpened;
  end;

var
  MainForm: TMainForm;
  ToggleWindows: TTogglewindows;
  AutoAttachThread: TAutoAttachThread;

implementation


uses mainunit2, ProcessWindowUnit, MemoryBrowserFormUnit, TypePopup, HotKeys,
  aboutunit, formhotkeyunit, formDifferentBitSizeUnit,
  CommentsUnit, formsettingsunit, formAddressChangeUnit, Changeoffsetunit,
  FoundCodeUnit, advancedoptionsunit, frmProcessWatcherUnit,
  formPointerOrPointeeUnit, OpenSave, formmemoryregionsunit, formProcessInfo,
  PasteTableentryFRM, pointerscannerfrm, PointerscannerSettingsFrm,
  frmFloatingPointPanelUnit, pluginexports, DBK32functions, frmUltimapUnit,
  frmSetCrosshairUnit, StructuresFrm2, frmMemoryViewExUnit,
  frmD3DHookSnapshotConfigUnit, frmSaveSnapshotsUnit, frmsnapshothandlerUnit,
  frmNetworkDataCompressionUnit, ProcessHandlerUnit, ProcessList, pointeraddresslist,
  PointerscanresultReader, Parsers, Globals, GnuAssembler, xinput, DPIHelper,
  multilineinputqueryunit, winsapi, LuaClass, Filehandler, feces,
  frmDBVMWatchConfigUnit, frmDotNetObjectListUnit, ceregistry, UnexpectedExceptionsHelper;

resourcestring
  rsInvalidStartAddress = 'Invalid start address: %s';
  rsInvalidStopAddress = 'Invalid stop address: %s';
  rsThisButtonWillTryToCancelTheCurrentScanClickTwiceT =
    'This button will try to cancel the current scan. Click twice to force an exit';
  rsCancel = 'Cancel';
  strWindowFailedToHide = 'A window failed to hide';
  strAccessed = 'The following opcodes accessed the selected address';
  strOpcodeRead = 'The following opcodes read from the selected address';
  strOpcodeChanged = 'The following opcodes changed the selected address';
  strAskToSave = 'You haven''t saved your last changes yet. Save Now?';
  strScantextcaptiontotext = 'Text:';
  strScantextcaptiontoValue = 'Value:';
  strsearchForText = 'Search for text';
  strSearchForArray = 'Search for this array';
  rsValue = 'Value %';
  rsBetween = 'between %';
  rsAtLeastXx = 'at least xx%';
  rsAnd = 'and';
  strConfirmProcessTermination =
    'This will close the current process. Are you sure you want to do this?';
  strError = 'Error';
  strErrorwhileOpeningProcess = 'Error while opening this process';
  strKeepList = 'Keep the current address list/code list?';
  strInfoAboutTable = 'Info about this table:';
  strPhysicalMemory = 'Physical Memory';
  strSaferPhysicalMemory = 'Safer memory access';
  rsThereAreOneOrMoreAutoAssemblerEntriesOrCodeChanges =
    'There are one or more auto assembler entries or code changes enabled in this table. Do you want them disabled? (without '
    + 'executing the disable part)';
  rsLoadTheAssociatedTable = 'Load the associated table? (%s)';
  rsGroup = 'Group %s';
  rsGroups = 'Groups';
  rsWhatDoYouWantTheGroupnameToBe = 'What do you want the groupname to be?';
  rsAreYouSureYouWantToDeleteThisForm = 'Are you sure you want to delete this form?';
  rsRenameFile = 'Rename file';
  rsGiveTheNewFilename = 'Give the new filename';
  rsRestoreAndShow = 'Restore and show';
  rsEdit = 'Edit';
  rsDelete = 'Delete';
  rsRename = 'Rename';
  rsSaveToDisk = 'Save to disk';
  rsAreYouSureYouWantToDelete = 'Are you sure you want to delete %s?';
  rsCheatEngine = 'Cheat Engine';
  rsWhatWillBeTheNewNameForThisTab = 'What will be the new name for this tab?';
  rsScan = 'Scan';
  rsScanresult = 'Scanresult';
  rsSaveScanResults = 'Save scan results';
  rsWhatNameDoYouWantToGiveToTheseScanresults =
    'What name do you want to give to these scanresults?';
  rsThankYouForTryingOutCheatEngineBecauseItHasExpired =
    'Thank you for trying out Cheat Engine. Because it has expired Cheat Engine will now close. Is that ok with you?';
  rsWHATAreYouSayingYouReGoingToContinueUsingCEILLEGAL =
    'WHAT!!! Are you saying you''re going to continue using CE ILLEGALLY??? If you say yes, i''m going to mail the cops to '
    + 'get you and send you to jail!!!';
  rsHrmpfBecauseIMInAGoodMoodILlLetYouGoThisTimeButDon =
    'Hrmpf... Because I''m in a good mood i''ll let you go this time. But don''t do it again you filthy pirate';
  rsAprilFools = 'April fools!!!!';
  strClickToGoHome = 'Click here to go to the Cheat Engine homepage';
  rsLuaScriptCheatTable = 'Lua script: Cheat Table';
  strChangeDescription1 = 'Description';
  strChangeDescription2 = 'Change the description to:';

  strNotTheSameSize1 = 'The text you entered isn''t the same size as the original. Continue?';
  strNotTheSameSize2 = 'Not the same size!';
  strAdd0 = 'Do you want to add a ''0''-terminator at the end?';
  strNotAValidNotation = 'This is not a valid notation';
  strNotSameAmmountofBytes =
    'The number of bytes you typed is not the same as the previous ammount. Continue?';
  strNotAValidBinaryNotation = ' is not a valid binary notation!';

  strValue = 'Value';
  strChange1Value = 'Change this value to:';
  strChangeMoreValues = 'Change these values to:';

  strSelectedAddressIsAPointer =
    'The selected address is a pointer. Are you sure? (the base pointer will get the address)';
  strMorePointers = 'There are more pointers selected. Do you want to change them as well?';
  strMorePointers2 =
    'You have selected one or more pointers. Do you want to change them as well?';
  strNotAValidValue = 'This is not an valid value';
  rsComparingToF = 'Comparing to first scan results';
  rsTheRecordWithDescriptionHasAsInterpretableAddressT =
    'The record with description ''%s'' has as interpretable address ''%s''. The recalculation will change it to %s. Do you '
    + 'want to edit it to the new address?';
  rsSavedScanResults = 'Saved scan results';
  rsSelectTheSavedScanResultFromTheListBelow =
    'Select the saved scan result from the list below';
  rsComparingTo = 'Comparing to %s';
  rsHex = 'Hex';
  rsDoYouWantToGoToTheCheatEngineWebsite =
    'Do you want to go to the Cheat Engine website?';

  strdeleteall = 'Are you sure you want to delete all addresses?';
  stralreadyin = 'This address is already in the list';
  stralreadyinlistmultiple = 'One or more addresses where already in the list';
  strsethotkey = 'Set a hotkey';
  strshowasdecimal = 'Show as decimal value';
  strshowashex = 'Show as hexadecimal value';
  strFreezeAddressInList = 'Freeze the address in this list';
  strFreezeAllAddresses = 'Freeze all addresses in this list';
  strUnfreezeAllAddresses = 'Unfreeze all addresses in this list';
  strUnfreezeAddressInList = 'Unfreeze the address in this list';
  strDeleteAddress = 'Delete this address';
  strDeleteTheseAddresses = 'Delete these addresses';
  strRecalculateAddress = 'Recalculate address';
  strRecalculateSelectedAddresses = 'Recalculate selected addresses';
  strRecalculateAllAddresses = 'Recalculate all addresses';

  strRemoveFromGroup = 'Remove from group ';

  strChangeScript = 'Change script';
  strEnableCheat = 'Enable cheat';
  strDisableCheat = 'Disable cheat';

  strForceRecheck = 'Force recheck symbols';
  rsSetChangeHotkeys = 'Set/Change hotkeys';
  rsSetHotkeys = 'Set hotkeys';
  rsShowAsDecimal = 'Show as decimal';
  rsShowAsBinary = 'Show as binary';
  rsShowAsHexadecimal = 'Show as hexadecimal';
  rsRemoveSelectedAddresses = 'Remove selected addresses';
  rsRemoveSelectedAddress = 'Remove selected address';
  rsThisListIsHuge =
    'This list is huge and deleting multiple items will require CE to traverse the whole list and can take a while. Are you sure?';
  rsFindOutWhatAccessesThisPointer = 'Find out what accesses this pointer';
  rsFindWhatAccessesTheAddressPointedAtByThisPointer =
    'Find what accesses the address pointed at by this pointer';
  rsFindOutWhatWritesThisPointer = 'Find out what writes this pointer';
  rsFindWhatWritesTheAddressPointedAtByThisPointer =
    'Find what writes the address pointed at by this pointer';

  strconfirmUndo = 'Do you really want to go back to the results of the previous scan?';

  strHideForeground = 'will hide the foreground window';
  strHideAll = 'will hide all windows';
  strUnHideForeground = 'will bring the foreground window back';
  strUnhideAll = 'will bring all windows back';
  rsBringsCheatEngineToFront = 'brings Cheat Engine to front';

  strhappybirthday = 'Let''s sing Happy Birthday for Dark Byte today!';
  strXMess = 'Merry christmas and happy new year';
  strNewyear = 'And what are your good intentions for this year? ;-)';
  strfuture = 'Wow,I never imagined people would use Cheat Engine up to today';
  rsLicenseExpired =
    'Your license to use Cheat Engine has expired. You can buy a license to use cheat engine for 1 month for $200, 6 months for only $1000 and for 1 year for ' + 'only $1800. If you don''t renew your license Cheat Engine will be severely limited in it''s abilities. (e.g: Next scan has been disabled)';
  rsEXPIRED = 'EXPIRED';
  strdontbother =
    'Don''t even bother. Cheat Engine uses the main thread to receive messages when the scan is done, freeze it and CE will crash!';
  rsTheProcessIsnTFullyOpenedIndicatingAInvalidProcess =
    'The process isn''t fully opened. Indicating a invalid ProcessID. You still want to find out the EPROCESS? (BSOD is '
    + 'possible)';
  rsUnrandomizerInfo =
    'This will scan for and change some routines that are commonly used to generate a random value so they always return the same. Please be aware that there ' + 'is a chance it overwrites the wrong routines causing the program to crash, or that the program uses an unknown random generator. Continue?';

  strUnknownExtension = 'Unknown extension';
  rsDoYouWishToMergeTheCurrentTableWithThisTable =
    'Do you wish to merge the current table with this table?';
  rsDoYouWantToProtectThisTrainerFileFromEditing =
    'Do you want to protect this trainer file from editing?';
  rsAutoAssembleEdit = 'Auto Assemble edit: %s';
  rsEditAddresses = 'Edit addresses';
  rsScanError = 'Scan error:%s';
  rsShown = 'shown';
  rsTerminatingScan = 'Terminating scan...';
  rsThisButtonWillForceCancelAScanExpectMemoryLeaks =
    'This button will force cancel a scan. Expect memory leaks';
  rsForceTermination = 'Force termination';
  rsYouAreLowOnDiskspaceOnTheFolderWhereTheScanresults =
    'You are low on diskspace on the folder where the scanresults are stored. Scanning might fail. Are you sure you want to '
    + 'continue?';
  rsIsNotAValidSpeed = '%s is not a valid speed';
  rsAreYouSureYouWantToEraseTheDataInTheCurrentTable =
    'Are you sure you want to erase the data in the current table?';


  rsSaved = 'Saved';
  rsPrevious = 'Previous';

  rsDecimal = 'Decimal';
  rsHexadecimal = 'Hexadecimal';
  rsIsNotAValidX = '%s is not a valid xml name';
  rsMUGenerateGroupscanCommand = 'Generate groupscan command';
  rsTryTutorial = 'Do you want to try out the tutorial?';
  rsUnspecifiedError = 'Unspecified error';
  rsGroupscanDataInvalid = 'groupscan data invalid';
  rsGroupscanResultWithNoGroupscanparser = 'Groupscan result with no groupscanparser';
  rsFailedToLoad = 'failed to load';
  rsFailureSettingTheDebugPrivilege = 'Failure setting the debug privilege. Debugging may be limited.';
  rsFailureSettingTheSeTcbPrivilegePrivilege = 'Failure setting the SeTcbPrivilege privilege. Debugging may be limited.';
  rsFailureSettingTheLoadDriverPrivilege = 'Failure setting the load driver privilege. Debugging may be limited.';
  rsFailureSettingTheCreateGlobalPrivilege = 'Failure setting the CreateGlobal privilege.';
  rsCurrentProcess = 'Current process';
  rsNone = '<none>';
  rsBusy = '<busy>';
  rsFileInUse = '<File in use>';
  rsCEError = 'CE Error:';
  rsPart = ' part ';
  rsChangeValue = 'Change value';
  rsGiveTheNewValueForTheSelectedAddressEs = 'Give the new value for the selected address(es)';
  rsOverlay = 'overlay ';
  rsWasClickedAtPositon = ' was clicked at positon ';
  rsWidth = '   -   width=';
  rsHeight = ' , height=';
  rsUnableToScanFixYourScanSettings = 'Unable to scan. Fix your scan settings and restart cheat engine';
  rsCustomLuaType = 'Custom LUA type';
  rsCustomTypeName = 'Custom Type Name';
  rsLanguage = 'Language';
  rsChooseLanguage = 'Which language do you wish to use?';
  rsInvalidScanFolder = '%s is not accessible like it should.  Please '
    +'configure a proper location in the settings';
  rsProcessing = '<Processing>';

var
  ncol: TColor;

procedure TFlash.Col;
begin
  mainform.panel7.Color := ncol;
end;

procedure TFlash.Execute;
var
  red, green: byte;
  decreasered: boolean;
begin

{$ifndef ceasinjecteddll}
  decreasered := True;
  red := 254;
  green := 0;
  while not terminated do
  begin
    if decreasered then
    begin
      Dec(red, 2);
      Inc(green, 2);
      if green >= 250 then
        decreasered := False;
    end
    else
    begin
      Inc(red, 2);
      Dec(green, 2);
      if red >= 254 then
        decreasered := True;
    end;
    ncol := (green shl 8) + red;

    if not terminated then
      synchronize(col);

    sleep(10);
  end;

{$endif}
  ncol := clBtnFace;
  synchronize(col);
end;

constructor TToggleWindows.Create(CreateSuspended: boolean);
begin
  freeonterminate := True;
  inherited Create(CreateSuspended);
end;

procedure TToggleWindows.Execute;
begin
  toggleotherwindows;
  togglewindows := nil;
end;

procedure TMainForm.setIsProtected(p: boolean); //super unhackable protection yeeeeeh
//I'll sue you for DMCA violations if you edit this code!!!! Really! I mean it! I do!!!!
var
  i: integer;
begin
  fIsProtected := p;

  if p then
  begin

    //It's fucking time!!!!
    FreeAndNil(advancedoptions);
    FreeAndNil(actionlist1);

    for i := 0 to ControlCount - 1 do
      Controls[i].Visible := False;

    mainform.menu := nil;

    addresslist.PopupMenu := nil;
    addresslist.Enabled := False;

    Visible := False;

    miTable.Enabled := False;
    while miTable.Count > 0 do
      miTable.Delete(0);

    FreeAndNil(changescript1);

    frmLuaTableScript.assemblescreen.ClearAll;
    frmLuaTableScript.assemblescreen.Text:='wut?';
  end;
end;

procedure TMainForm.CheckForSpeedhackKey(sender: TObject);
var
  s: integer;
  down: boolean;
begin
//  if speed
  s:=ttimer(sender).tag;
  down:=false;

  case s of
    1: down:=CheckKeyCombo(speedhackspeed1.keycombo);
    2: down:=CheckKeyCombo(speedhackspeed2.keycombo);
    3: down:=CheckKeyCombo(speedhackspeed3.keycombo);
    4: down:=CheckKeyCombo(speedhackspeed4.keycombo);
    5: down:=CheckKeyCombo(speedhackspeed5.keycombo);
  end;

  if not down then
  begin
    editsh2.Text := '1';
    btnSetSpeedhack2.Click;
    ttimer(sender).enabled:=false;
  end;
end;

procedure TMainForm.Hotkey2(var Message: TMessage);
type
  PNotifyEvent = ^TNotifyEvent;
var
  i: integer;
  a, b: single;
  s: string;

  hk: TMemoryRecordHotkey;
  gh: TGenericHotkey;

  hOtherWin : THandle;
  OtherThreadID : DWORD;
  CurrentThreadID : DWORD;
  lockTimeOut: DWORD;
  pid: dword;
begin
  if message.LParam <> 0 then
  begin
    case message.wparam of
      0: //memoryrecord hotkey
      begin
        hk := TMemoryRecordHotkey(message.LParam);
        hk.DoHotkey;
      end;

      1: //OnNotify hotkey
      begin
        gh := TGenericHotkey(message.LParam);
        gh.onNotify(gh);
      end
    end;
  end
  else
    case message.WParam of
      0:
      begin
        GetWindowThreadProcessId(GetForegroundWindow, pid);
        ce_openProcess(pid);
      end;
      1:
      begin
        //popup/hide CE
        if advancedoptions.Pausebutton.Down then
        begin
          errorbeep;
          exit;
        end;

        hOtherWin := GetForegroundWindow;
        GetWindowThreadProcessID( hOtherWin, OtherThreadID);
        CurrentThreadID := GetCurrentThreadID;

        if CurrentThreadID<>OtherThreadID then
        begin
          AttachThreadInput( CurrentThreadID, OtherThreadID, true );
          SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @lockTimeOut, 0);
          SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, nil, 0);
          AllowSetForegroundWindow(ASFW_ANY);
        end;

        beep;

        if formsettings.cbHideAllWindows.Checked then
        begin
          ToggleWindow;

          if formsettings.cbCenterOnPopup.Checked then
            if not allwindowsareback then
              setwindowpos(mainform.Handle, HWND_NOTOPMOST, (screen.Width div 2) -
                (mainform.Width div 2), (screen.Height div 2) -
                (mainform.Height div 2), mainform.Width, mainform.Height,
                SWP_NOZORDER or SWP_NOACTIVATE);

          if not allwindowsareback then
          begin
            application.BringToFront;
            if CurrentThreadID<>OtherThreadID then
            begin
              SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, @lockTimeOut, 0);
              AttachThreadInput( CurrentThreadID, OtherThreadID, false );
            end;
          end
          else
            setforegroundwindow(lastforeground);

          adjustbringtofronttext;
          exit;
        end;

        application.BringToFront;
        SetForegroundWindow(mainform.Handle);

        mainform.SetFocus;

        if CurrentThreadID<>OtherThreadID then
        begin
          SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, @lockTimeOut, 0);
          AttachThreadInput( CurrentThreadID, OtherThreadID, false );
        end;

        if formsettings.cbCenterOnPopup.Checked then
          setwindowpos(mainform.Handle, HWND_NOTOPMOST, (screen.Width div 2) -
            (mainform.Width div 2), (screen.Height div 2) -
            (mainform.Height div 2), mainform.Width, mainform.Height,
            SWP_NOZORDER or SWP_NOACTIVATE);

        formstyle := fsStayOnTop;
      end;

      2: //Pause
      begin
        with advancedoptions do
        begin
          pausedbyhotkey := True;
          pausebutton.down := not pausebutton.down;
          pausebutton.Click;
          pausedbyhotkey := False;
        end;
      end;

      3: //speedhack
      begin
        if cbSpeedhack.Enabled then
        begin
          try
            cbSpeedhack.Checked := not cbSpeedhack.Checked;
            btnSetSpeedhack2.Click;
            beep;
          except
            errorbeep;
          end;
        end;
      end;

      //3..7=set speedhack speed
      4:
      begin
        if cbspeedhack.Enabled then
        begin
          try
            cbspeedhack.Checked := True;

            if cbspeedhack.Checked then
            begin
              editsh2.Text := format('%.3f', [speedhackspeed1.speed]);  //Just rebuild. I wish this would get fixed in fpc someday...
              btnSetSpeedhack2.Click;

              if speedhackspeed1.disablewhenreleased then
              begin
                //spawn a timer
                if speedhackDisableTimer=nil then
                begin
                  speedhackDisableTimer:=TTimer.create(self);
                  speedhackDisableTimer.OnTimer:=CheckForSpeedhackKey;
                end;

                speedhackDisableTimer.Interval:=hotkeyPollInterval;
                speedhackDisableTimer.Tag:=1;
                speedhackDisableTimer.enabled:=true;
              end;

            end;
          except
            errorbeep;
          end;
        end;
      end;

      5:
      begin
        if cbspeedhack.Enabled then
        begin
          cbspeedhack.Checked := True;
          if cbspeedhack.Checked then
          begin
            editsh2.Text := format('%.3f', [speedhackspeed2.speed]);
            btnSetSpeedhack2.Click;

            if speedhackspeed2.disablewhenreleased then
            begin
              //spawn a timer
              if speedhackDisableTimer=nil then
              begin
                speedhackDisableTimer:=TTimer.create(self);
                speedhackDisableTimer.OnTimer:=CheckForSpeedhackKey;
              end;

              speedhackDisableTimer.Interval:=hotkeyPollInterval;
              speedhackDisableTimer.Tag:=2;
              speedhackDisableTimer.enabled:=true;
            end;
          end;
        end;
      end;

      6:
      begin
        if cbspeedhack.Enabled then
        begin
          cbspeedhack.Checked := True;
          if cbspeedhack.Checked then
          begin
            editsh2.Text := format('%.3f', [speedhackspeed3.speed]);
            btnSetSpeedhack2.Click;

            if speedhackspeed3.disablewhenreleased then
            begin
              //spawn a timer
              if speedhackDisableTimer=nil then
              begin
                speedhackDisableTimer:=TTimer.create(self);
                speedhackDisableTimer.OnTimer:=CheckForSpeedhackKey;
              end;

              speedhackDisableTimer.Interval:=hotkeyPollInterval;
              speedhackDisableTimer.Tag:=3;
              speedhackDisableTimer.enabled:=true;
            end;
          end;
        end;
      end;

      7:
      begin
        if cbspeedhack.Enabled then
        begin
          cbspeedhack.Checked := True;
          if cbspeedhack.Checked then
          begin
            editsh2.Text := format('%.3f', [speedhackspeed4.speed]);
            btnSetSpeedhack2.Click;

            if speedhackspeed4.disablewhenreleased then
            begin
              //spawn a timer
              if speedhackDisableTimer=nil then
              begin
                speedhackDisableTimer:=TTimer.create(self);
                speedhackDisableTimer.OnTimer:=CheckForSpeedhackKey;
              end;

              speedhackDisableTimer.Interval:=hotkeyPollInterval;
              speedhackDisableTimer.Tag:=4;
              speedhackDisableTimer.enabled:=true;
            end;
          end;
        end;
      end;

      8:
      begin
        if cbspeedhack.Enabled then
        begin
          cbspeedhack.Checked := True;
          if cbspeedhack.Checked then
          begin
            editsh2.Text := format('%.3f', [speedhackspeed5.speed]);
            btnSetSpeedhack2.Click;

            if speedhackspeed5.disablewhenreleased then
            begin
              //spawn a timer
              if speedhackDisableTimer=nil then
              begin
                speedhackDisableTimer:=TTimer.create(self);
                speedhackDisableTimer.OnTimer:=CheckForSpeedhackKey;
              end;

              speedhackDisableTimer.Interval:=hotkeyPollInterval;
              speedhackDisableTimer.Tag:=5;
              speedhackDisableTimer.enabled:=true;
            end;
          end;
        end;
      end;

      9:
      begin
        //increase speed
        try
          if cbspeedhack.Enabled then
          begin
            cbspeedhack.Checked := True;
            if cbspeedhack.Checked then
            begin
              a := strtofloat(editsh2.Text);
              a := a + speedupdelta;
              editsh2.Text := format('%.3f', [a]);
              btnSetSpeedhack2.Click;
            end;
          end;
        except

        end;
      end;


      10:
      begin
        //decrease speed
        try
          if cbspeedhack.Enabled then
          begin
            cbspeedhack.Checked := True;
            if cbspeedhack.Checked then
            begin
              b := strtofloat(editsh2.Text);
              b := b - slowdowndelta;
              editsh2.Text := format('%.3f', [b]);
              btnSetSpeedhack2.Click;
            end;
          end;
        except

        end;
      end;

      11..19: //Change type (if possible)
      begin
        if vartype.Enabled then
          vartype.ItemIndex := message.WParam - 3
        else
        begin
          errorbeep;
        end;
      end;

      20://new scan
      begin

        if not btnNewScan.Enabled then
          exit; //only when no process is opened

        i := vartype.ItemIndex;

        if btnNewScan.Caption = strNewScan then
          btnNewScan.Click; //start new scan

        vartype.ItemIndex := i;
        vartype.OnChange(vartype); //set previous type
      end;

      21: //new scan Exact value
      begin

        if not btnNewScan.Enabled then
          exit;

        i := vartype.ItemIndex;
        s := scanvalue.Text;
        if s = '' then
          exit;

        if btnNewScan.Caption = strNewScan then
          btnNewScan.Click; //start new scan

        vartype.ItemIndex := i;
        vartype.OnChange(vartype); //set previous type

        scanvalue.Text := s;
        btnNewScan.Click;
      end;

      22: //new scan unknown initial value
      begin

        if not btnNewScan.Enabled then
          exit;

        i := vartype.ItemIndex;

        if btnNewScan.Caption = strNewScan then
          btnNewScan.Click; //start new scan

        vartype.ItemIndex := i;
        vartype.OnChange(vartype);

        scantype.ItemIndex := scantype.Items.IndexOf(StrUnknownInitialValue);
        scantype.OnChange(scantype);

        btnNewScan.Click;
      end;

      23: //next scan Exact value
      begin

        if not btnNewScan.Enabled then
          exit;


        if btnNextScan.Enabled then
        begin
          scantype.ItemIndex := scantype.Items.IndexOf(StrExactValue);
          scantype.OnChange(scantype);

          btnNextScan.click;
        end
        else
          Errorbeep;
      end;

      24: //next scan IncreasedValue
      begin

        if not btnNewScan.Enabled then
          exit;


        if btnNextScan.Enabled then
        begin
          scantype.ItemIndex := scantype.Items.IndexOf(StrIncreasedValue);
          scantype.OnChange(scantype);

          btnNextScan.click;
        end
        else
          Errorbeep;
      end;

      25: //next scan DecreasedValue
      begin

        if not btnNewScan.Enabled then
          exit;


        if btnNextScan.Enabled then
        begin
          scantype.ItemIndex := scantype.Items.IndexOf(StrDecreasedValue);
          scantype.OnChange(scantype);

          btnNextScan.click;
        end
        else
          Errorbeep;
      end;

      26: //next scan ChangedValue
      begin

        if not btnNewScan.Enabled then
          exit;


        if btnNextScan.Enabled then
        begin
          scantype.ItemIndex := scantype.Items.IndexOf(StrChangedValue);
          scantype.OnChange(scantype);

          btnNextScan.click;
        end
        else
          Errorbeep;
      end;

      27: //next scan unchangedValue
      begin

        if not btnNewScan.Enabled then
          exit;


        if btnNextScan.Enabled then
        begin
          scantype.ItemIndex := scantype.Items.IndexOf(StrUnchangedValue);
          scantype.OnChange(scantype);

          btnNextScan.click;
        end
        else
          Errorbeep;
      end;

      28: //next scan same as first
      begin
        if not btnNewScan.Enabled then
          exit;


        if btnNextScan.Enabled then
        begin
          scantypechangedbyhotkey := True;
          scantype.ItemIndex := scantype.Items.Count - 1;
          scantype.OnChange(scantype);
          scantypechangedbyhotkey := False;
        end
        else
          Errorbeep;
      end;

      29: //undo lastscan
      begin

        if not btnNewScan.Enabled then
          exit;


        if undoscan.Enabled then
          undoscan.Click
        else
          Errorbeep;
      end;

      30: //cancel current scan
      begin
        if cancelbutton <> nil then
          cancelbutton.Click;
      end;

      31: //debug->run
      begin
        if memorybrowser.miDebugRun.enabled then
          MemoryBrowser.miDebugRun.Click;
      end;

    end;

end;

procedure TMainForm.hotkey(var Message: TMessage);
//stays because the old hotkeyhandler is still used in some places
begin

  if (formhotkey <> nil) and (formhotkey.Visible) then
    exit;

  if Message.wparam = 0 then
  begin
    //bring to front
    try
      unregisterhotkey(mainform.handle, 0);

      if advancedoptions.Pausebutton.Down then
      begin
        beep;
        sleep(100);
        beep;
        sleep(100);
        beep;
        sleep(100);
        exit;
      end;

      beep;

      if formsettings.cbHideAllWindows.Checked then
      begin
        ToggleWindow;

        //      ToggleOtherWindows;

        if formsettings.cbCenterOnPopup.Checked then
          if not allwindowsareback then
            setwindowpos(mainform.Handle, HWND_NOTOPMOST, (screen.Width div 2) -
              (mainform.Width div 2), (screen.Height div 2) - (mainform.Height div
              2), mainform.Width, mainform.Height, SWP_NOZORDER or SWP_NOACTIVATE);

        if not allwindowsareback then
          application.BringToFront
        else
        begin
          setforegroundwindow(lastforeground);
          //   setactivewindow(lastactive);
        end;

        adjustbringtofronttext;
        exit;
      end;


      // if length(windowlist)<>0 then
      application.BringToFront;

      if formsettings.cbCenterOnPopup.Checked then
        setwindowpos(mainform.Handle, HWND_NOTOPMOST, (screen.Width div 2) -
          (mainform.Width div 2), (screen.Height div 2) - (mainform.Height div
          2), mainform.Width, mainform.Height, SWP_NOZORDER or SWP_NOACTIVATE);

      formstyle := fsStayOnTop;

    finally
      registerhotkey(mainform.handle, 0, message.lparamlo, message.LParamHi);
      //restore the hotkey
    end;
  end;


  if message.WParam = 2 then //toggle speedhack
  begin

    try
      unregisterhotkey(mainform.handle, 2);
      if cbSpeedhack.Enabled then
      begin
        beep;
        cbSpeedhack.Checked := not cbSpeedhack.Checked;
      end;
    finally
      registerhotkey(mainform.handle, 2, message.lparamlo, message.LParamHi);
      //restore the hotkey
    end;

  end;

end;


procedure TMainForm.PluginSync(var m: TMessage);
var
  func: TPluginFunc;
  params: pointer;
begin
  func := pointer(m.wparam);
  params := pointer(m.lparam);


  m.Result := ptruint(func(params));
end;

procedure TMainForm.ShowError(var message: TMessage);
var err: pchar;
begin
  err:=pchar(message.lParam);
  if err<>nil then
  begin
    MessageDlg(err, mtError, [mbOK], 0);
    freememandnil(err);
  end
  else
    MessageDlg(rsUnspecifiedError, mtError, [mbOK], 0);
end;

//----------------------------------

function TMainForm.getSelectedVariableType: TVariableType;
  {wrapper for the new getVarType2 in the new scanroutine}
begin
  Result := getVarType2;
end;

function TMainForm.getScanStart: ptruint;
begin
  try

    Result := StrToQWordEx('$' + FromAddress.Text);
  except
    raise Exception.Create(Format(rsInvalidStartAddress, [FromAddress.Text]));
  end;
end;

procedure TMainForm.setScanStart(newscanstart: ptruint);
begin
  FromAddress.Text := inttohex(newscanstart, 8);
end;

function TMainForm.getScanStop: ptruint;
begin
  try
    Result := StrToQWordEx('$' + ToAddress.Text);
  except
    raise Exception.Create(Format(rsInvalidStopAddress, [ToAddress.Text]));
  end;
end;

procedure TMainForm.setScanStop(newscanstop: ptruint);
begin
  ToAddress.Text := inttohex(newscanstop, 8);
end;


function TMainForm.getFastscan: boolean;
begin
  Result := cbFastscan.Enabled and cbFastscan.Checked;
end;

procedure TMainForm.setFastScan(state: boolean);
begin
  cbFastscan.Checked := state;
end;




function TMainForm.GetRoundingType: TRoundingType;
  {Property function to get the current rounding type}
begin
  Result := rtTruncated;
  if rt1.Checked then
    Result := rtRounded
  else
  if rt2.Checked then
    Result := rtExtremerounded
  else
  if rt3.Checked then
    Result := rtTruncated;
end;

procedure TMainForm.SetRoundingType(rt: TRoundingType);
{Property function to set the current rounding type}
begin
  case rt of
    rtRounded: rt1.Checked;
    rtExtremerounded: rt2.Checked;
    rtTruncated: rt3.Checked;
  end;
end;


procedure TMainForm.setfoundcount(x: int64);
var
  xdouble: double;
begin
  ffoundcount := x;
  xdouble := x;
  foundcountlabel.Caption := Format('%.0n', [xdouble]);
end;

procedure TMainForm.DestroyCancelButton;
begin
  if cancelbutton <> nil then
    FreeAndNil(cancelbutton);
  if cancelbuttonenabler <> nil then
    FreeAndNil(cancelbuttonenabler);
end;

procedure TMainForm.SpawnCancelButton;
begin
  cancelbutton := TButton.Create(self);
  with cancelbutton do
  begin
    Anchors := btnNewScan.Anchors;
    top := btnNewScan.top;
    left := btnNewScan.left;
    Width := (btnNextScan.left + btnNextScan.Width) - left;
    Height := btnNewScan.Height;
    Caption := rsCancel;
    onclick := cancelbuttonclick;
    Enabled := False;
    tag := 0; //0=normal 1=force

    Hint := rsThisButtonWillTryToCancelTheCurrentScanClickTwiceT;
    ParentShowHint := False;
    ShowHint := True;


    cancelbutton.Anchors:=[];
    cancelbutton.AnchorSideLeft.Control:=btnNewScan;
    cancelbutton.AnchorSideLeft.Side:=asrLeft;
    cancelbutton.Anchors:=[akLeft, akTop];
    cancelbutton.name:='CancelButton';

    parent := panel5;
  end;

  cancelbuttonenabler := TTimer.Create(self);

  with cancelbuttonenabler do
  begin
    interval := 2000; //2 seconds
    OnTimer := cancelbuttonenablerinterval;
    Enabled := True;
  end;
end;


procedure TMainForm.disableGui;
{
This procedure will disable the gui. E.g while scanning the memory with no wait
screen.
}
begin
  setGbScanOptionsEnabled(False);

  scanvalue.Enabled := False;
  if scanvalue2 <> nil then
  begin
    scanvalue2.Enabled := False;
    andlabel.Enabled := False;
    scantext2.Enabled := False;
  end;

  vartype.Enabled := False;
  scantype.Enabled := False;
  scantext.Enabled := False;
  lblScanType.Enabled := False;
  lblValueType.Enabled := False;
  cbHexadecimal.Enabled := False;
  cbCaseSensitive.Enabled := False;

  btnNewScan.Enabled := False;
  btnNextScan.Enabled := False;
  undoscan.Enabled := False;

  cbNot.Enabled:=false;
end;

procedure TMainForm.enableGui(isnextscan: boolean);
{
Enables the gui options according to what type of scan is currently used
no scan, enable everything
already scanning, disable the group and type
}
var
  scanstarted: boolean;
begin

  scanstarted := btnNewScan.Caption = strnewscan;

  if not scanstarted then
  begin
    setGbScanOptionsEnabled(True);
  end;

  scanvalue.Enabled := True;
  if scanvalue2 <> nil then
  begin
    scanvalue2.Enabled := True;
    andlabel.Enabled := True;
    scantext2.Enabled := True;
  end;
  btnNewScan.Enabled := True;

  undoscan.Enabled := isnextscan and memscan.canUndo; //nextscan was already enabled
  btnNextScan.Enabled := scanstarted;
  vartype.Enabled := not scanstarted;
  scantype.Enabled := True;
  scantext.Enabled := True;
  lblScanType.Enabled := True;
  lblValueType.Enabled := True;
  cbHexadecimal.Enabled := True;
  cbCaseSensitive.Enabled := True;
  cbNot.enabled:=true;


  scanvalue.Visible := True;
  scantext.Visible := True;

  Updatescantype;
  Scantype.ItemIndex := 0;

  //-----------------------
  //Get the expectedFilename
  //-----------------------
  SetExpectedTableName;

  cbspeedhack.Enabled := True;
  cbunrandomizer.Enabled := True;

end;



procedure TMainForm.toggleWindow;
var
  c: integer;
begin
  togglewindows := TTogglewindows.Create(False);
  c := 0;
  while togglewindows <> nil do
  begin
    if c = 500 then
    begin
      freeandnil(togglewindows);
      raise Exception.Create(strWindowFailedToHide);
    end;
    sleep(10);
    Inc(c);
  end;
end;


procedure TMainForm.exceptionhandler(Sender: TObject; E: Exception);
var err: pchar;
begin
  //unhandled exeption. Also clean lua stack
  getmem(err, length(e.Message)+1);
  strcopy(err, pchar(e.message));
  err[length(e.message)]:=#0;

  PostMessage(handle, wm_showerror, 0, ptruint(err));
end;



function TMainForm.CheckIfSaved: boolean;
var
  help: word;
begin
  //result:=true;
  Result := not editedsincelastsave;


  if itemshavechanged then
    Result := False;

  if Result = False then
  begin
    help := messagedlg(strAskToSave, mtConfirmation, mbYesNoCancel, 0);
    case help of
      mrCancel: Result := False;
      mrYes:
      begin

        SaveButton.click;
        result:=not savegotcanceled;
      end;
      else
        Result := True;
    end;
  end;
end;





//--------------------------cbpercentage--------------
procedure TMainForm.cbPercentageOnChange(Sender: TObject);
begin
  if cbpercentage.Checked then
  begin
    //turn this into a double value scan like "value between"
    CreateScanValue2;
    ScanText.Caption := rsValue;
    ScanText2.Caption := rsValue;
  end
  else
  begin
    if ScanType.Text <> strValueBetween then
    begin
      //single value scan
      ScanText.Caption := strScantextcaptiontoValue;
      DestroyScanValue2;
    end
    else
    begin
      ScanText.Caption := strScantextcaptiontoValue;
      ScanText2.Caption := strScantextcaptiontoValue;
    end;
  end;
end;

procedure TMainForm.CreateCbPercentage;
begin
  cbpercentage.visible:=true;

  if ScanType.Text = strValueBetween then
    cbpercentage.Caption := rsBetween
  else
    cbpercentage.Caption := rsAtLeastXx;

  UpdateFloatRelatedPositions;
end;

procedure TMainForm.DestroyCbPercentage;
begin
  cbpercentage.Visible:=false;
end;
//------------------

procedure TMainForm.CreateScanValue2;
var
  oldwidth: integer;
  editsize: integer;
begin
  scantext2.Caption := scantext.Caption;

  andlabel.Visible:=true;
  scanvalue2.visible:=true;
  scantext2.visible:=true;

  panel5.OnResize(panel5);
end;

procedure TMainForm.DestroyScanValue2;
begin
  scanvalue2.visible:=false;
  scantext2.visible:=false;
  andlabel.visible:=false;
end;

procedure TMainForm.UpdateScanType;
var
  OldText: string;
  OldIndex: integer;
  hexvis: boolean;
  floatvis: boolean;
  t: TStringList;
  old, old2: TNotifyEvent;
  ct: Tcustomtype;
begin
  old := scantype.OnChange;
  old2 := scantype.OnSelect;
  scantype.OnChange := nil;
  scantype.OnSelect := nil;

  try
    OldIndex := Scantype.ItemIndex;
    OldText := Scantype.Text;
    hexvis := True;
    floatvis := False;

    ScanType.Items.Clear;

    ScanText.Caption := strScantextcaptiontoValue;

    if (varType.ItemIndex in [1, 2, 3, 4, 5, 6, 9,10]) or (vartype.ItemIndex >= 11) then
      //byte-word-dword--8bytes-float-double-all   - custom
    begin

      if (vartype.ItemIndex in [5, 6, 9, 10]) or (vartype.ItemIndex >= 11) then //float/all/grouped, custom
      begin
        ct:=TCustomtype(vartype.Items.Objects[vartype.itemindex]);
        if (ct=nil) or (ct.scriptUsesFloat) then
        begin
          //handle as a float value
          if oldindex = 0 then
            floatvis := True;

          if vartype.ItemIndex <> 9 then
            hexvis := False;
        end;
      end;

      ScanType.Items.Add(strExactValue);
      ScanType.Items.Add(strBiggerThan);
      ScanType.Items.Add(strsmallerThan);
      ScanType.Items.Add(strValueBetween);

      if btnNextScan.Enabled then
      begin
        scantype.Items.Add(strIncreasedValue);
        Scantype.Items.Add(strIncreasedValueBy);
        ScanType.Items.Add(strDecreasedValue);
        ScanType.Items.Add(strDecreasedValueBy);
        ScanType.Items.add(strChangedValue);
        ScanType.Items.Add(strUnchangedValue);

        if compareToSavedScan then
          ScanType.Items.Add(strCompareToLastScan)
        else
        begin
          t := TStringList.Create;
          if memscan.getsavedresults(t) > 1 then
            ScanType.Items.Add(strcompareToSavedScan)
          else
            ScanType.Items.Add(strCompareToFirstScan);

          freeandnil(t);

        end;

      end
      else
      begin
        ScanType.Items.Add(strUnknownInitialValue);

      end;

    end
    else
      case varType.ItemIndex of
        0:
        begin
          ScanType.Items.Add(strExact);

        end;



        7:
        begin  //text
          ScanText.Caption := strScanTextCaptionToText;
          ScanType.Items.Add(strSearchForText);
          //perhaps also a changed value and unchanged value scan

          hexvis := False;
        end;

        8:
        begin  //array of bytes
          ScanText.Caption := vartype.Items[8];
          ScanType.Items.Add(strSearchforarray);

        end;

      end;
    Scantype.DropDownCount := Scantype.items.Count;



    if (oldtext = strUnknownInitialValue) and (btnNextScan.Enabled) then
      scantype.ItemIndex := 0
    else
      scantype.ItemIndex := oldindex;

    if (scantype.Text = strIncreasedValueBy) or (scantype.Text = strDecreasedValueBy) or
      (scantype.Text = strValueBetween) then
    begin
      if btnNextScan.Enabled then
        createCbPercentage;

    end
    else
    begin
      destroyCbPercentage;

    end;

    if scantype.Text = strValueBetween then
      CreateScanValue2
    else
      DestroyScanValue2;


    if (scantype.Text = strIncreasedValue) or (scantype.Text = strDecreasedValue) or
      (scantype.Text = strChangedValue) or (scantype.Text = strUnchangedValue) or
      (scantype.Text = strUnknownInitialValue) then
    begin
      Scantext.Visible := False;
      Scanvalue.Visible := False;
      cbHexadecimal.Visible := False;
      cbNot.visible:=false;
    end
    else
    begin
      Scantext.Visible := True;
      Scanvalue.Visible := True;
      cbHexadecimal.Visible := hexvis;

      cbNot.Visible:=not (vartype.itemindex in [0,7,8,10]);
    end;

    pnlfloat.Visible := floatvis;

    if rbBit.Visible then
      cbHexadecimal.Visible := False;

    pnlScanValueOptions.visible:=(cbHexadecimal.Visible or rbDec.visible or rbBit.Visible);


    //save the last scantype (if it wasn't the option to change between first/last)
    if (scantype.ItemIndex <> -1) and (scantype.ItemIndex < scantype.Items.Count) then
    begin
      if not ((scantype.items[scantype.ItemIndex] = strcompareToSavedScan) or
        (scantype.items[scantype.ItemIndex] = strCompareToLastScan)) then
        lastscantype := scantype.ItemIndex;
    end;

    if (not cbHexadecimal.Visible) and (cbHexadecimal.checked) then //not visible but checked
    begin
      cbHexadecimal.checked:=hexvis;
    end;

    UpdateFloatRelatedPositions;

  finally
    scantype.OnChange := old;
    scantype.OnSelect := old2;
  end;
end;


procedure TMainForm.reinterpretaddresses;
begin
  if addresslist <> nil then
    addresslist.ReinterpretAddresses;
end;



procedure TMainForm.AddAutoAssembleScript(script: string);
begin
  addresslist.addAutoAssembleScript(script);
end;

procedure TMainForm.AddToRecord(Line: integer; node: TTreenode = nil;
  attachmode: TNodeAttachMode = naAdd);
var
  Address: ptrUint;
  startbit: integer;
  i,l: integer;

  vt: TVariableType;
  tempvartype: TVariableType;
  addressstring: string;
  newaddresstring: string;

  ct: TCustomType;
  customname: string;
  m: TMemoryRecord;
  ga: PGroupAddress;

  gcp: TGroupscanCommandParser;

  extra: dword;
  value: string;
begin

  //first check if this address is already in the list!
  customname := '';
  l := 0;
  startbit := 0;
  extra:=0;
  ct:=nil;
  gcp:=nil;
  ga:=nil;

  vt := getvartype;
  if vt = vtBinary then //binary
  begin
    startbit := foundlist.getstartbit(line);
    l := memscan.Getbinarysize;
  end
  else
  if vt = vtAll then //all
  begin
    address:=foundlist.GetAddress(line, extra, Value);

    if extra >= $1000 then
    begin
      ct:=TCustomType(customTypes[extra - $1000]);
      customname := ct.Name;
      vt:=vtCustom;
    end
    else
    begin
      ct:=nil;
      vt := TVariableType(foundlist.getstartbit(line));
    end;


  end
  else
  if vt=vtCustom then //custom
  begin
    ct := TCustomType(vartype.items.objects[vartype.ItemIndex]);
    customname := ct.Name;
  end
  else
  begin
    startbit := 0;
    l := foundlist.GetVarLength;
  end;
  address := foundlist.GetAddress(line);

  if foundlist.inmodule(line) then
    addressString := foundlist.GetModuleNamePlusOffset(line)
  else
    addressstring := inttohex(address, 8);


  if vt=vtGrouped then
  begin
    //add as a group
    ga:=foundlist.GetGroupAddress(line);
    if ga=nil then
      raise exception.create(rsGroupscanDataInvalid);

    gcp:=foundlist.getGCP;
    if gcp=nil then
      raise exception.create(rsGroupscanResultWithNoGroupscanparser);


    for i:=0 to length(gcp.elements)-1 do
    begin
      if gcp.elements[i].picked then
      begin
        if gcp.elements[i].customtype<>nil then
          customname:=gcp.elements[i].customtype.name
        else
          customname:='';

        l:=gcp.elements[i].bytesize;

        vt:=gcp.elements[i].vartype;
        if vt=vtUnicodeString then
        begin
          vt:=vtString;
          l:=l div 2;
        end;

        newaddresstring:=addressstring+'+'+inttohex(ga.offsets[i],1);
        addresslist.addaddress(strNoDescription, newaddresstring, [], 0, vt, customname, l, 0, gcp.elements[i].vartype=vtUnicodeString, node, attachmode);
      end;
    end;

  end
  else
  begin
    m := addresslist.addaddress(strNoDescription, addressString, [], 0,
      vt, customname, l, startbit, False, node, attachmode);

    m.showAsHex:=foundlist.isHexadecimal;

    if m.VarType = vtBinary then
      m.Extra.bitData.showasbinary := rbBit.Checked
    else
    if (m.VarType = vtString) then
    begin
      m.Extra.stringData.unicode := foundlist.isUnicode;
      m.Extra.stringData.codepage := memscan.codePage;
    end;
  end;

end;

procedure TMainForm.SetExpectedTableName;
var
  fname: string;
  expectedfilename: string;
begin
  if UserDefinedTableName<>'' then exit;


  Fname := copy(processlabel.Caption, pos('-', processlabel.Caption) + 1,
    length(processLabel.Caption));


  if (length(fname)>3) and (FName[length(FName) - 3] = '.') then  //it's a filename
    expectedFilename := copy(FName, 1, length(FName) - 4)
  else //it's a normal title;
    expectedFilename := FName;

  savedialog1.FileName := expectedFilename;
  Opendialog1.FileName := expectedFilename;
end;



function TMainForm.openprocessPrologue: boolean;
begin

  Result := False;

  if flashprocessbutton <> nil then
  begin
    flashprocessbutton.Terminate;
    FreeAndNil(flashprocessbutton);
  end;


  canceled := False;
  Result := True;
end;

procedure TMainForm.openProcessEpilogue(oldprocessname: string; oldprocess: dword; oldprocesshandle: dword; autoattachopen: boolean);
var
  i, j: integer;
  fname, expectedfilename: string;

  wasActive: boolean;
  DoNotOpenAssociatedTable: boolean;
  //set to true if the table had AA scripts enabled or the code list had nopped instruction
begin

  DoNotOpenAssociatedTable:=false;

  outputdebugstring('openProcessEpilogue called');

  symhandler.reinitialize(true);
//  symhandler.waitforsymbolsloaded;

  reinterpretaddresses;

  miNetwork.visible:=processhandler.isNetwork;

  if oldprocess = 0 then //set disassembler and hexview of membrowser to what the main header says
    memorybrowser.setcodeanddatabase;

  outputdebugstring('After setcodeanddatabase');

  if processid = $FFFFFFFF then
  begin
    processlabel.Caption := strPhysicalMemory;
    cbPauseWhileScanning.visible:=false;

    if cbsaferPhysicalMemory=nil then
    begin
      cbsaferPhysicalMemory:=tcheckbox.create(self);
      cbsaferPhysicalMemory.Caption:=strSaferPhysicalMemory;
      cbsaferPhysicalMemory.Checked:=dbk32functions.saferQueryPhysicalMemory;
      cbsaferPhysicalMemory.Parent:=cbPauseWhileScanning.Parent;
      cbsaferPhysicalMemory.left:=cbPauseWhileScanning.left;
      cbsaferPhysicalMemory.Top:=cbPauseWhileScanning.top;
      cbsaferPhysicalMemory.OnChange:=cbSaferPhysicalMemoryChange;
    end;
  end
  else
  begin
    //restore cbPauseWhileScanning if it was replaced
    if cbSaferPhysicalMemory<>nil then
    begin
      freeandnil(cbsaferPhysicalMemory);
      cbPauseWhileScanning.Visible:=true;
    end;
  end;



  if (processhandle = 0) then
  begin
    outputdebugstring('processhandle is 0, so disabling gui');

    if btnNewScan.Caption = strNewScan then
      btnNewScan.click;

    //disable everything

    foundcount := 0;
    foundlist.Clear;

    btnNewScan.Caption := strFirstScan;

    setGbScanOptionsEnabled(False);


    scanvalue.Enabled := False;
    btnNewScan.Enabled := False;
    btnNextScan.Enabled := False;
    vartype.Enabled := False;
    scantype.Enabled := False;
    scantext.Enabled := False;
    lblScanType.Enabled := False;
    lblValueType.Enabled := False;

    scanvalue.Visible := False;
    scantext.Visible := False;
    scanvalue.Text := '';
    cbHexadecimal.Enabled := False;
    cbCaseSensitive.Enabled := False;
    cbNot.Visible:=false;

    Updatescantype;
    Scantype.ItemIndex := 0;

    cbSpeedhack.Enabled := False;
    cbUnrandomizer.Enabled := False;



    if processid <> $FFFFFFFF then
    begin

      processlabel.Caption := strError;
      raise Exception.Create(strErrorWhileOpeningProcess);
    end
    else
    begin
      processlabel.Caption := strPhysicalMemory;
    end;

    UpdateScanType;


    //apply this for all tabs
    if scantablist <> nil then
      for i := 0 to scantablist.Count - 1 do
        SaveCurrentState(PScanState(scantablist.TabData[i]), true);

  end;

  if (processID = oldProcess) then
    exit;

  outputdebugstring('oldprocessid != processid');

  //a new process has been selected
  cbspeedhack.Enabled := True;
  cbunrandomizer.Enabled := True;

  if not autoattachopen then
  begin
    if (addresslist.Count > 0) or (advancedoptions.codelist2.items.Count > 0) then
    begin
      if (messagedlg(strKeepList, mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
      begin
        UserDefinedTableName:='';
        ClearList;
      end
      else
      begin
        //yes, so keep the list
        //go through the list and chek for auto assemble entries, and check if one is enabled. If so, ask to disable (withotu actually disabling)
        wasActive := False;
        DoNotOpenAssociatedTable:=true; //user kept the list, do not load the associated table

        for i := 0 to addresslist.Count - 1 do
          if (addresslist[i].VarType = vtAutoAssembler) and (addresslist[i].active) then
          begin
            wasActive := True;
            break;
          end;

        if not wasActive then
        begin
          for i := 0 to length(AdvancedOptions.code) - 1 do
            if AdvancedOptions.code[i].changed then
            begin
              wasActive := True;
              break;
            end;
        end;

        if wasactive then
        begin
          if (messagedlg(rsThereAreOneOrMoreAutoAssemblerEntriesOrCodeChanges,
            mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
          begin
            addresslist.disableAllWithoutExecute;

            for i := 0 to length(AdvancedOptions.code) - 1 do
              AdvancedOptions.code[i].changed := False;
          end;

        end;
      end;

    end;
  end
  else
  begin
    cbSpeedhack.Checked:=false;
  end;

  enablegui(btnNextScan.Enabled);

  Fname := copy(processlabel.Caption, pos('-', processlabel.Caption) +
    1, length(processLabel.Caption));

  if (length(fname)>3) and (FName[length(FName) - 3] = '.') then  //it's a filename
    expectedFilename := copy(FName, 1, length(FName) - 4) + '.ct'
  else //it's a normal title;
    expectedFilename := FName + '.ct';


  if not (autoattachopen or DoNotOpenAssociatedTable) then
  begin
    if fileexists(TablesDir +  pathdelim + expectedfilename) or fileexists(expectedfilename) or
      fileexists(cheatenginedir + expectedfilename) then
    begin
      if messagedlg(Format(rsLoadTheAssociatedTable, [expectedFilename]),
        mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      begin
        autoopen := True;
        if fileexists(TablesDir + pathdelim + expectedfilename) then
          opendialog1.FileName := TablesDir + pathdelim + expectedfilename
        else
        if fileexists(expectedfilename) then
          opendialog1.FileName := expectedfilename
        else
          opendialog1.FileName := cheatenginedir + expectedfilename;

        LoadButton.Click;
      end;
    end;
  end;
  UpdateScanType;

  if scantablist <> nil then
    for i := 0 to scantablist.Count - 1 do
      SaveCurrentState(PScanState(scantablist.TabData[i]),true);


  outputdebugstring('openProcessEpilogue exit');

 // miDotNET.visible:=symhandler.hasDotNetAccess; //too slow to use. You're free to uncomment it but don't bitch about having to wait 2 and a half hour

  if assigned(fOnProcessOpened) then
    fOnProcessOpened(processid, processhandle, processlabel.Caption);
end;

procedure TMainForm.ShowProcessListButtonClick(Sender: TObject);
var
  oldprocess: Dword;
  resu: integer;
  oldprocesshandle: thandle;
  oldprocessname: string;
begin
  if not openprocessPrologue then
    exit;

  oldprocessname := copy(mainform.ProcessLabel.Caption, pos(
    '-', mainform.ProcessLabel.Caption) + 1, length(mainform.ProcessLabel.Caption));

  oldprocess := processID;
  oldprocesshandle := processhandle;

  if Processwindow = nil then
    ProcessWindow := TProcessWindow.Create(application);

  resu := ProcessWindow.ShowModal;

  if resu = mrCancel then
    exit;

  openProcessEpilogue(oldprocessname, oldprocess, oldprocesshandle);
end;

procedure TMainForm.rbAllMemoryChange(Sender: TObject);
begin

end;

procedure TMainForm.rbFsmAlignedChange(Sender: TObject);
begin
  if rbfsmLastDigts.Checked then
    alignsizechangedbyuser := False;

  VarType.OnChange(vartype);
end;

procedure TMainForm.Save1Click(Sender: TObject);
var
  protect: boolean;
begin
  protect := False;
  if (savedialog1.FileName = '') then
    actSave.Execute
  else
    savetable(savedialog1.FileName);
end;

procedure TMainForm.Description1Click(Sender: TObject);
begin
  addresslist.doDescriptionChange;
end;

procedure TMainForm.edtAlignmentKeyPress(Sender: TObject; var Key: char);
begin
  if rbFsmAligned.Checked then
    alignsizechangedbyuser := True;
end;

procedure TMainForm.FormDropFiles(Sender: TObject; const FileNames: array of string);
begin
  if length(filenames) > 0 then
  begin
    if CheckIfSaved then
    begin
      LoadTable(filenames[0], False);
      reinterpretaddresses;
    end;
  end;
end;

procedure TMainForm.Foundlist3CustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: boolean);
var
  s: string;
begin
  if foundlist <> nil then
  begin
    if foundlist.inmodule(item.index) then
      foundlist3.Canvas.Font.Color := clgreen
    else
      foundlist3.Canvas.Font.Color := GetSysColor(COLOR_WINDOWTEXT);
  end;
end;

procedure TMainForm.Foundlist3CustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
var r: trect;
  ts: TTextStyle;
  drawn:boolean;
begin
  drawn:=false;
  if miShowPreviousValue.checked and (PreviousResults<>nil) then
  begin
    if (item.subItems[1]<>'<none>') and (item.subitems[0]<>item.subitems[1]) then
    begin
      sender.Canvas.Font.color:=clred;
      sender.canvas.font.Style:=sender.canvas.font.Style+[fsBold];
      sender.canvas.Refresh;
      drawn:=true;
    end;
  end;
  if(not drawn)then
  begin
    sender.Canvas.Font.color:=GetSysColor(COLOR_WINDOWTEXT);
  end;
end;

procedure TMainForm.Address1Click(Sender: TObject);
begin
  addresslist.doAddressChange;
end;

procedure TMainForm.cbCodePageChange(Sender: TObject);
begin
  if cbCodePage.checked then cbunicode.Checked:=false;
end;

procedure TMainForm.cbUnicodeChange(Sender: TObject);
begin
  if cbunicode.checked then cbCodePage.checked:=false;
end;

procedure TMainForm.Copyselectedaddresses1Click(Sender: TObject);
var
  i: ptruint;
  temp: string;
begin
  temp:='';
  if foundlist3.SelCount = 1 then
    clipboard.AsText := symhandler.getNameFromAddress(StrToQWordEx('$'+foundlist3.Items[foundlist3.itemindex].Caption))
  else
  if foundlist3.SelCount > 1 then
  begin
    for i:=0 to foundlist3.Items.count-1 do
    begin
      if foundlist3.items[i].Selected then
        temp := temp + symhandler.getNameFromAddress(StrToQWordEx('$'+foundlist3.Items[i].Caption)) + sLineBreak;
    end;
    clipboard.AsText := temp;
  end;
end;

procedure TMainForm.EnableLCLClick(Sender: TObject);
var llf: TLazLoggerFile;
begin
  llf:=GetDebugLogger;
  if llf<>nil then
  begin
    if miEnableLCLDebug.checked then
    begin
      deletefile('cedebug.txt');

      llf.LogName:='cedebug.txt';
      llf.Init;

      DebugLn('First log message');
    end
    else
      llf.Finish;
  end;


end;

procedure TMainForm.actOpenDissectStructureExecute(Sender: TObject);
var address: ptruint;
  i: integer;
  f: TfrmStructures2;
  found: boolean;
  c: TStructColumn;
begin

  if frmStructures2.count>0 then
  begin
    if addresslist.Focused and (addresslist.selectedRecord<>nil) and (addresslist.selectedRecord.isGroupHeader=false) and (addresslist.selectedRecord.VarType<>vtAutoAssembler) then
    begin
      //add this address if it's not yet in the list
      found:=false;

      address:=addresslist.selectedRecord.GetRealAddress;
      f:=TfrmStructures2(frmStructures2[0]);
      for i:=0 to f.columnCount-1 do
        if f.columns[i].Address=address then
        begin
          found:=true;
          f.columns[i].focus;
          break;
        end;

      if not found then
      begin
        c:=f.addColumn;
        c.Address:=address;
        c.focus;
      end;
    end;

    TfrmStructures2(frmStructures2[0]).show;
  end
  else
  begin
    //create it
    with tfrmstructures2.create(application) do
    begin
      //fill in the selected memoryrecord if there is one, else use the memoryview hexview address
      initialaddress:=MemoryBrowser.hexview.address;

      if (addresslist.selectedRecord<>nil) and (addresslist.selectedRecord.isGroupHeader=false) and (addresslist.selectedRecord.VarType<>vtAutoAssembler) then
        initialaddress:=addresslist.selectedRecord.GetRealAddress;

      show;
    end;
  end;
end;

procedure TMainForm.actOpenLuaEngineExecute(Sender: TObject);
begin
  MemoryBrowser.miLuaEngine.Click;
end;

procedure TMainForm.cbFastScanChange(Sender: TObject);
begin
  edtAlignment.Enabled := cbFastScan.Checked and cbfastscan.Enabled;
  rbFsmAligned.Enabled := edtAlignment.Enabled;
  rbfsmLastDigts.Enabled := edtAlignment.Enabled;

  alignsizechangedbyuser := False;
  VarType.OnChange(vartype);
end;

procedure TMainForm.cbUnrandomizerChange(Sender: TObject);
begin

end;




procedure TMainForm.CreateGroupClick(Sender: TObject);
var
  groupname: string;
  i: integer;
  Count: integer;
begin
  //in rare cases you can use the treeview data data if you request so
  Count := 0;
  for i := 0 to addresslist.Items.Count - 1 do
    if TMemoryRecord(addresslist.Items[i].Data).isGroupHeader then
      Inc(Count);

  groupname := Format(rsGroup, [IntToStr(Count + 1)]);

  if InputQuery(rsGroups, rsWhatDoYouWantTheGroupnameToBe, groupname) then
    addresslist.CreateGroup(groupname);
end;

procedure TMainForm.Foundlist3SelectItem(Sender: TObject; Item: TListItem;
  Selected: boolean);
begin

end;

procedure TMainForm.Label3Click(Sender: TObject);
var x:TChangeRegOnBPInfo;
begin
 // x.changeRIP
end;

procedure TMainForm.MenuItem12Click(Sender: TObject);
begin
  shellexecute(0, 'open', pchar(cheatenginedir+'Tutorial-x86_64.exe'), nil, nil, sw_show);
end;

procedure TMainForm.MenuItem15Click(Sender: TObject);
var nexttut: string;
    filename: string;
begin
  filename:='gtutorial-'+{$ifdef cpu32}'i386'{$else}'x86_64'{$endif}+'.exe';
  nexttut:=ExtractFilePath(application.ExeName)+filename;

  if fileexists(nexttut) then
  begin
    //launch the graphical tutorial
    ShellExecute(0, PChar('open'), PChar(nexttut),PChar(''), PChar(extractfilepath(nexttut)), SW_SHOW);
    exit;
  end;


  nexttut:=ExtractFileDir(application.ExeName);

  if ExtractFileName(nexttut)='bin' then
  begin
    nexttut:=ExtractFilePath(nexttut)+'tutorial\graphical\'+filename;

    if fileexists(nexttut) then
    begin
      //launch the graphical tutorial
      ShellExecute(0, PChar('open'), PChar(nexttut),PChar(''), PChar(extractfilepath(nexttut)), SW_SHOW);
      exit;
    end;
  end;
end;

procedure TMainForm.miAutoAssembleErrorMessageClick(Sender: TObject);
begin
  addresslist.doValueChange;
end;

procedure TMainForm.miHelpClick(Sender: TObject);
begin
  miEnableLCLDebug.visible:=miEnableLCLDebug.checked or (ssCtrl in GetKeyShiftState);
end;

procedure TMainForm.miLuaDocumentationClick(Sender: TObject);
begin
  ShellExecute(0,'open',pchar(ExtractFilePath(application.ExeName)+'celua.txt'),nil,nil,SW_SHOW);
end;

procedure TMainForm.miForgotScanClick(Sender: TObject);
begin
  if (foundlist.count=0) or (memscan.lastScanWasRegionScan) then exit;

  if PreviousResults<>nil then
    freeandnil(PreviousResults);

  foundlist.Deinitialize; //unlock file handles

  if cbPauseWhileScanning.Checked then
  begin
    advancedoptions.Pausebutton.down := True;
    advancedoptions.Pausebutton.Click;
  end;

  ProgressBar.min := 0;
  ProgressBar.max := 1000;
  ProgressBar.position := 0;

  lastscantype := scantype.ItemIndex;
  memscan.nextscan(soForgot, rtRounded,'','', false, false,false,false,false,false,'');
  DisableGui;
  SpawnCancelButton;
end;


procedure TMainForm.miGetDotNetObjectListClick(Sender: TObject);
begin
  if frmDotNetObjectList=nil then
    frmDotNetObjectList:=TfrmDotNetObjectList.create(self);

  frmDotNetObjectList.show;
  frmDotNetObjectList.loadlist;
end;



procedure TMainForm.miSignTableClick(Sender: TObject);
begin
  if Opendialog1.Execute then
    signTablefile(opendialog1.filename);
end;


var t: TRemoteMemoryManager;

procedure TMainForm.miScanDirtyOnlyClick(Sender: TObject);
begin
  scan_dirtyonly:=miScanDirtyOnly.checked;
end;

procedure TMainForm.miCompressionClick(Sender: TObject);
begin
  if frmNetworkDataCompression=nil then
    frmNetworkDataCompression:=tfrmNetworkDataCompression.create(self);

  frmNetworkDataCompression.show;
end;


procedure TMainForm.miManualExpandCollapseClick(Sender: TObject);
begin
  miManualExpandCollapse.Checked := not miManualExpandCollapse.Checked;

  if addresslist.selectedRecord <> nil then
  begin
    if miManualExpandCollapse.Checked then
      addresslist.selectedRecord.options :=
        addresslist.selectedRecord.options + [moManualExpandCollapse]
    else
      addresslist.selectedRecord.options :=
        addresslist.selectedRecord.options - [moManualExpandCollapse];
  end;
end;

procedure TMainForm.miSaveClick(Sender: TObject);
begin
  if fileexists(savedialog1.FileName) then
    savetable(savedialog1.FileName, false)
  else
    actSave.Execute;
end;

procedure TMainForm.mi3dClick(Sender: TObject);
begin
  miHookD3D.checked:=(D3DHook<>nil) and (D3DHook.processid=processid);

  miLockMouseInGame.enabled:=miHookD3D.checked;
  miSetCrosshair.enabled:=miHookD3D.checked;

  if miHookD3D.checked=false then
    miLockMouseInGame.checked:=false;

end;

procedure TMainForm.miChangeDisplayTypeClick(Sender: TObject);
begin
  //set the display type to override the default with
  foundlistDisplayOverride:=TMenuItem(sender).Tag;
  foundlist3.Refresh;
end;

procedure TMainForm.miOpenFileClick(Sender: TObject);
var
  oldprocess: Dword;
  resu: integer;
  oldprocesshandle: thandle;
  oldprocessname: string;
begin
  if not openprocessPrologue then
    exit;

  oldprocessname := copy(mainform.ProcessLabel.Caption, pos(
    '-', mainform.ProcessLabel.Caption) + 1, length(mainform.ProcessLabel.Caption));

  oldprocess := processID;
  oldprocesshandle := processhandle;

  if Processwindow = nil then
    ProcessWindow := TProcessWindow.Create(application);

  ProcessWindow.miOpenFile.click;

  if ProcessWindow.modalresult=mrOK then
    openProcessEpilogue(oldprocessname, oldprocess, oldprocesshandle);
end;

procedure TMainForm.miScanPagedOnlyClick(Sender: TObject);
begin
  scan_pagedonly:=miScanPagedOnly.checked;
end;

procedure TMainForm.miSetDropdownOptionsClick(Sender: TObject);
begin
  if addresslist.selectedrecord<>nil then
    TFrmMemoryRecordDropdownSettings.create(addresslist.SelectedRecord).showmodal;
end;


procedure TMainForm.miShowAsSignedClick(Sender: TObject);
var
  i: integer;
  newstate: boolean;
begin
  if addresslist.selectedRecord <> nil then
  begin
    newstate := not addresslist.selectedRecord.showAsSigned;

    for i := 0 to addresslist.Count - 1 do
      if addresslist[i].isSelected then
        addresslist[i].showAsSigned := newstate;
  end;

end;




procedure TMainForm.MenuItem1Click(Sender: TObject);
begin
  addresslist.SelectAll;
end;

procedure TMainForm.miShowLuaScriptClick(Sender: TObject);
begin
  frmLuaTableScript.Show;
end;

procedure TMainForm.miAddAddressClick(Sender: TObject);
begin
  SpeedButton3.Click;
end;

procedure TMainForm.miAllowCollapseClick(Sender: TObject);
begin
  miAllowCollapse.Checked := not miAllowCollapse.Checked;

  if addresslist.selectedRecord <> nil then
  begin
    if miAllowCollapse.Checked then
      addresslist.selectedRecord.options := addresslist.selectedRecord.options + [moAllowManualCollapseAndExpand]
    else
      addresslist.selectedRecord.options := addresslist.selectedRecord.options - [moAllowManualCollapseAndExpand];
  end;
end;

procedure TMainForm.updated3dgui;
begin
  miSetCrosshair.Enabled := d3dhook<>nil;
  miWireframe.Enabled := d3dhook<>nil;
  miZbuffer.Enabled := d3dhook<>nil;
  miLockMouseInGame.enabled := d3dhook<>nil;
end;

procedure TMainForm.miHookD3DClick(Sender: TObject);
begin
  safed3dhook;

  updated3dgui;
end;

procedure TMainForm.miSnapshothandlerClick(Sender: TObject);
begin
  if frmSnapshotHandler=nil then
  begin
    frmSnapshotHandler:=tfrmSnapshotHandler.Create(application);
    frmSnapshotHandler.show;
    if D3DHook<>nil then
      frmSnapshotHandler.miConfig.click; //configure it if needed
  end
  else
    frmSnapshotHandler.show;
end;

procedure TMainForm.miLockMouseInGameClick(Sender: TObject);
begin
  safed3dhook;
  updated3dgui;

  if d3dhook<>nil then
    d3dhook.setMouseClip(miLockMouseInGame.checked);
end;

procedure TMainForm.miPresetAllClick(Sender: TObject);
begin
  cbWritable.State := cbGrayed;
  cbCopyOnWrite.state := cbGrayed;
  cbExecutable.state := cbGrayed;
end;

procedure TMainForm.miAddFileClick(Sender: TObject);
var
  f: TOpendialog;

  lf: TLuafile;
  s: TMemorystream;
  i: integer;
begin
  f := TOpendialog.Create(self);
  try
    f.Options:=f.options+[ofAllowMultiSelect, ofFileMustExist];
    if f.Execute then
    begin
      s := TMemorystream.Create;

      for i:=0 to f.Files.Count-1 do
      begin
        s.clear;
        s.LoadFromFile(f.Files[i]);
        lf := TLuaFile.Create(extractfilename(f.files[i]), s);
        LuaFiles.add(lf);
      end;
      freeandnil(s);
    end;

  finally
    if f<>nil then
      freeandnil(f);
  end;
end;

procedure TMainForm.MenuItem9Click(Sender: TObject);

begin
  if frmTrainerGenerator = nil then
    frmTrainerGenerator := tfrmTrainerGenerator.Create(self);

  if frmTrainerGenerator.canceled then
  begin
    frmTrainerGenerator.Close;
    exit;
  end;



  frmTrainerGenerator.Show;

end;

procedure TMainForm.miPresetWritableClick(Sender: TObject);
begin
  cbWritable.State := cbchecked;
  cbCaseSensitive.state := cbGrayed;
  cbExecutable.state := cbGrayed;
end;

procedure TMainForm.miResyncFormsWithLuaClick(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to LuaForms.Count - 1 do
    TCEForm(LuaForms[i]).ResyncWithLua;

end;

procedure TMainForm.DeleteFormClick(Sender: TObject);
var
  f: tceform;
begin
  if messagedlg(rsAreYouSureYouWantToDeleteThisForm, mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
  begin
    if LuaForms.Count = 1 then //close the designerform when it's the last object
      if FormDesigner <> nil then
        FormDesigner.Close;


    f := TCEForm(LuaForms[TMenuItem(Sender).Tag]);
    f.Free;

    LuaForms.Delete(TMenuItem(Sender).Tag);

    UpdateMenu;

  end;
end;

procedure TMainForm.EditFormClick(Sender: TObject);
var
  f: tceform;
begin
  f := TCEForm(LuaForms[TMenuItem(Sender).Tag]);


  if formdesigner = nil then
    createFormdesigner;

  formdesigner.designForm(f);      //opendialog my .ss

  formdesigner.Show;

  f.Show;
end;

procedure TMainForm.RestoreAndShowFormClick(Sender: TObject);
var
  f: tceform;
begin
  f := TCEForm(LuaForms[TMenuItem(Sender).Tag]);
  if f.designsurface <> nil then
    f.designsurface.Active := False;

  f.RestoreToDesignState;
  f.Show;
end;

procedure TMainForm.FormDesignerClose(Sender: TObject; var CloseAction: TCloseAction);
var
  i: integer;
  f: TCEForm;
begin
  for i := 0 to LuaForms.Count - 1 do
  begin
    f := TCEForm(LuaForms[i]);
    f.Active := False;
    if f.designsurface <> nil then
      FreeAndNil(f.designsurface);
  end;

  closeAction := caFree;
  FormDesigner := nil;
end;


procedure TMainForm.RenameFileClick(Sender: TObject);
var
  lf: TLuafile;
  newname: string;
begin
  lf := LuaFiles[TMenuItem(Sender).Tag];
  newname:=lf.Name;
  InputQuery(rsRenameFile, rsGiveTheNewFilename, newname);

  if IsXmlName(newname, true) then
    lf.name:=newname
  else
    MessageDlg(Format(rsIsNotAValidX, [newname]), mtError, [mbok], 0);
end;

procedure TMainForm.SaveFileClick(Sender: TObject);
var
  lf: TLuafile;
  f: TSavedialog;
begin
  lf := LuaFiles[TMenuItem(Sender).Tag];

  f := tsavedialog.Create(self);
  try
    f.filename := lf.Name;
    if f.Execute then
      lf.stream.SaveToFile(f.filename);
  finally
    freeandnil(f);
  end;
end;

procedure TMainForm.DeleteFileClick(Sender: TObject);
var
  lf: TLuafile;
begin
  lf := LuaFiles[TMenuItem(Sender).Tag];
  LuaFiles.Delete(TMenuItem(Sender).Tag);

  lf.Free;
  UpdateMenu;

end;

procedure TMainForm.UpdateMenu;
var
  i: integer;
  mi: tmenuitem;
  f: tceform;
  lf: TLuafile;

  submenu: TMenuItem;

  m: tmemorystream;
  b: tbitmap;
begin
  miLuaFormsSeperator.Visible := True; //LuaForms.Count>0;


  while miTable.Count > 5 do
  begin
    if miTable.Items[4] <> miLuaFormsSeperator then
      miTable.Delete(4)
    else
      break;
  end;

  for i := 0 to LuaForms.Count - 1 do
  begin
    mi := tmenuitem.Create(miTable);

    f := LuaForms[i];
    {
    //this currently won't work
    if f.icon<>nil then
    begin
      b:=tbitmap.create;
      b.Width := f.Icon.Width;
      b.Height := f.Icon.Height;
      b.Canvas.Draw(0, 0, f.Icon ) ;

      m:=tmemorystream.create;
      b.SaveToStream(m);
      m.position:=0;
      mi.Bitmap.LoadFromStream(m);
      m.free;
      b.free;
    end;}


    mi.Caption := f.Name;
    mi.ImageIndex:=16;
    miTable.Insert(4, mi);


    submenu := tmenuitem.Create(mi);
    submenu.Caption := rsRestoreAndShow;
    submenu.OnClick := RestoreAndShowFormClick;
    submenu.Tag := i;
    submenu.Default := True;
    mi.Add(submenu);

    submenu := tmenuitem.Create(mi);
    submenu.Caption := rsEdit;
    submenu.ImageIndex:=17;
    submenu.OnClick := EditFormClick;
    submenu.Tag := i;
    mi.Add(submenu);

    submenu := tmenuitem.Create(mi);
    submenu.Caption := '-';
    submenu.Tag := i;
    mi.Add(submenu);

    submenu := tmenuitem.Create(mi);
    submenu.Caption := rsDelete;
    submenu.ImageIndex:=22;
    submenu.OnClick := DeleteFormClick;
    submenu.Tag := i;
    mi.Add(submenu);
  end;


  //and now the files
  while miTable.Count > miTable.indexOf(miAddFile) + 1 do
    miTable.Delete(miTable.indexOf(miAddFile) + 1);

  for i := 0 to luafiles.Count - 1 do
  begin
    mi := tmenuitem.Create(miTable);
    lf := luafiles[i];
    mi.Caption := lf.Name;

    miTable.add(mi);

    submenu := tmenuitem.Create(mi);
    submenu.Caption := rsRename;
    submenu.ImageIndex:=17;
    submenu.OnClick := RenameFileClick;
    submenu.Tag := i;
    mi.Add(submenu);

    submenu := tmenuitem.Create(mi);
    submenu.Caption := rsSaveToDisk;
    submenu.ImageIndex:=4;
    submenu.OnClick := SaveFileClick;
    submenu.Tag := i;
    mi.Add(submenu);

    submenu := tmenuitem.Create(mi);
    submenu.Caption := '-';
    mi.Add(submenu);

    submenu := tmenuitem.Create(mi);
    submenu.Caption := rsDelete;
    submenu.ImageIndex:=22;
    submenu.OnClick := DeleteFileClick;
    submenu.Tag := i;
    mi.Add(submenu);

  end;

end;

procedure TMainForm.createFormdesigner;
begin
  if FormDesigner = nil then
  begin
    FormDesigner := TFormDesigner.Create(self);
    formdesigner.autosize := False;
    FormDesigner.OnClose2 := FormDesignerClose;
  end;
end;

procedure TMainForm.miCreateLuaFormClick(Sender: TObject);
var
  f: tceform;
  i, j, k: integer;

  s: string;

  br: TRect;
begin
  f := tceform.CreateNew(nil);
  f.autosize := False;

  j := 1;
  //found out a unique name for this form
  for i := 0 to LuaForms.Count - 1 do
  begin
    s := copy(tceform(LuaForms[i]).Name, 1, 3);
    if s = 'UDF' then
    begin
      s := tceform(LuaForms[i]).Name;
      s := copy(s, 4, length(s));
      if TryStrToInt(s, k) then
      begin
        if k >= j then
          j := k + 1;
      end;
    end;
  end;


  f.Name := 'UDF' + IntToStr(j);
  luaforms.add(f);




  if formdesigner = nil then
    createFormdesigner;

  formdesigner.designForm(f);

  formdesigner.Show;

  f.Show;

  f.left := formdesigner.left;

  LCLIntf.GetWindowRect(formdesigner.handle, br);
  f.top := br.Bottom + 5;

  updatemenu;
end;

procedure TMainForm.MenuItem7Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.miSetCrosshairClick(Sender: TObject);
begin
  if frmSetCrosshair = nil then
    frmSetCrosshair := TfrmSetCrosshair.Create(self);

  frmSetCrosshair.Show;
end;

procedure TMainForm.miTableClick(Sender: TObject);
begin
  UpdateMenu;
end;

procedure TMainForm.miResetRangeClick(Sender: TObject);
begin
  {$ifdef cpu64}
  FromAddress.Text := '0000000000000000';
  ToAddress.Text := '00007fffffffffff';
  {$else}
  FromAddress.Text := '00000000';
  if Is64bitOS then
    ToAddress.Text := 'ffffffff' //games with 3GB aware will use this in 64-bit os's
  else
    ToAddress.Text := '7fffffff';
  {$endif}
end;

procedure TMainForm.miChangeColorClick(Sender: TObject);
var
  i: integer;
begin
  if (addresslist.SelCount > 0) then
  begin
    colordialog1.Color:=addresslist.selectedRecord.Color;
    if (colordialog1.Execute) then
      for i := 0 to addresslist.Count - 1 do
        if addresslist[i].isSelected then
          addresslist[i].color := colordialog1.Color;
  end;
end;




procedure TMainForm.miBindActivationClick(Sender: TObject);
begin
  miBindActivation.Checked := not miBindActivation.Checked;

  if addresslist.selectedRecord <> nil then
  begin
    if miBindActivation.Checked then
      addresslist.selectedRecord.options := addresslist.selectedRecord.options + [moActivateChildrenAsWell]
    else
      addresslist.selectedRecord.options := addresslist.selectedRecord.options - [moActivateChildrenAsWell];
  end;
end;

procedure TMainForm.miBindDeactivationClick(Sender: TObject);
begin
  miBindDeactivation.Checked := not miBindDeactivation.Checked;

  if addresslist.selectedRecord <> nil then
  begin
    if miBindDeactivation.Checked then
      addresslist.selectedRecord.options := addresslist.selectedRecord.options + [moDeactivateChildrenAsWell]
    else
      addresslist.selectedRecord.options := addresslist.selectedRecord.options - [moDeactivateChildrenAsWell];
  end;
end;

procedure TMainForm.miDisassembleClick(Sender: TObject);
begin
  if addresslist.selectedrecord <> nil then
  begin
    memorybrowser.disassemblerview.SelectedAddress := addresslist.selectedrecord.GetRealAddress;
    memorybrowser.Show;
  end;
end;





procedure TMainForm.miHideChildrenClick(Sender: TObject);
begin
  miHideChildren.Checked := not miHideChildren.Checked;

  if addresslist.selectedRecord <> nil then
  begin
    if miHideChildren.Checked then
      addresslist.selectedRecord.options :=
        addresslist.selectedRecord.options + [moHideChildren]
    else
      addresslist.selectedRecord.options :=
        addresslist.selectedRecord.options - [moHideChildren];
  end;
end;

procedure TMainForm.setGbScanOptionsEnabled(state: boolean);
procedure setstaterecursive(c: TWinControl);
var i: integer;
begin
  c.enabled:=state;
  for i:=0 to c.ControlCount-1 do
  begin
    if (c.Controls[i] is TWinControl) then
      setstaterecursive(twincontrol(c.controls[i]))
    else
      c.controls[i].enabled:=state;
  end;

end;
begin
  setstaterecursive(gbScanOptions);
end;

procedure TMainForm.LoadCustomTypesFromRegistry;
var
  reg: TRegistry;
  customtypes: TStringList;
  i: integer;
  islua: boolean;
begin
  reg := tregistry.Create;
  vartype.OnChange := nil;
  //disable the onchange event so CreateCustomType doesn't keep setting it
  try
    if reg.OpenKey('\Software\Cheat Engine\CustomTypes\', False) then
    begin
      CustomTypes := TStringList.Create;
      reg.GetKeyNames(CustomTypes);
      for i := 0 to CustomTypes.Count - 1 do
      begin
        if reg.OpenKey('\Software\Cheat Engine\CustomTypes\' + CustomTypes[i], False) then
        begin
          try
            islua := False;
            if reg.ValueExists('lua') then
              islua := reg.ReadBool('lua');

            CreateCustomType(nil, reg.ReadString('Script'), True, islua);
          except
            outputdebugstring('The custom type script ''' + CustomTypes[i] +
              ''' could not be loaded');
          end;
        end;
      end;

      freeandnil(CustomTypes);
    end;
    freeandnil(reg);
    RefreshCustomTypes;
  finally
    vartype.OnChange := VarTypeChange;   //set the onchange event back
  end;
end;

procedure TMainForm.RefreshCustomTypes;
{
In short: remove all custom scan types and add them back
}
var
  i: integer;
begin
  vartype.items.BeginUpdate;
  try
    while VarType.Items.Count > 11 do
      vartype.items.Delete(11);


    for i := 0 to customTypes.Count - 1 do
      vartype.Items.AddObject(TCustomType(customTypes[i]).Name, customTypes[i]);

    //set to default (4 bytes) if not selected anything anymore
    if (vartype.ItemIndex = -1) or (vartype.ItemIndex >= VarType.Items.Count) then
      vartype.ItemIndex := 3;


  finally
    vartype.items.EndUpdate;
  end;

  vartype.DropDownCount := vartype.items.Count;

  addresslist.refreshcustomtypes;
end;

procedure TMainForm.miDeleteCustomTypeClick(Sender: TObject);
var
  reg: TRegistry;
  ct: TCustomType;
begin
  ct := TCustomType(vartype.Items.Objects[vartype.ItemIndex]);
  if (ct <> nil) and ((ct.CustomTypeType = cttAutoAssembler) or
    (ct.CustomTypeType = cttLuaScript)) then
  begin
    if messagedlg(Format(rsAreYouSureYouWantToDelete, [ct.Name]),
      mtConfirmation, [mbNo, mbYes], 0) = mrYes then
    begin
      reg := tregistry.Create;
      reg.DeleteKey('\Software\Cheat Engine\CustomTypes\' + ct.Name);
      ct.remove;
      RefreshCustomTypes;
    end;
  end;
end;

procedure TMainForm.CreateCustomType(customtype: TCustomtype;
  script: string; changed: boolean; lua: boolean = False);
var
  reg: TRegistry;
  ct: TCustomType;
  oldname: string;
  i: integer;
begin

  ct := nil;
  if changed then
  begin
    if customtype = nil then
    begin
      if not lua then
        ct := TCustomType.CreateTypeFromAutoAssemblerScript(script)
      else
        ct := TcustomType.CreateTypeFromLuaScript(script);
    end
    else
    begin
      //edited script

      ct := customtype;
      oldname := ct.Name;
      ct.setScript(script, lua);

      //if the new script has a different name then delete the old one
      if oldname <> ct.Name then
      begin
        //delete the old one
        reg := Tregistry.Create;
        reg.DeleteKey('\Software\Cheat Engine\CustomTypes\' + oldname);
        freeandnil(reg);
      end;
    end;



    //Add/change this to the registry
    reg := Tregistry.Create;
    if Reg.OpenKey('\Software\Cheat Engine\CustomTypes\' + ct.Name, True) then
    begin
      reg.WriteString('Script', script);
      if lua then
        reg.WriteBool('lua', True);

    end;

    freeandnil(reg);

    RefreshCustomTypes;

    //now set the type to the current type
    if (ct <> nil) then
    begin
      for i := 0 to vartype.Items.Count - 1 do
        if TCustomType(vartype.items.objects[i]) = ct then
        begin
          vartype.ItemIndex := i;
          if assigned(vartype.OnChange) then  //force an onchange (lazarus bug)
            vartype.OnChange(vartype);
          break;
        end;
    end;

  end;
end;



procedure TMainForm.miEditCustomTypeClick(Sender: TObject);
var
  ct: TCustomType;
begin
  ct := TCustomType(vartype.Items.Objects[vartype.ItemIndex]);
  if (ct <> nil) and ((ct.CustomTypeType = cttAutoAssembler) or
    (ct.CustomTypeType = cttLuaScript)) then
  begin

    with TfrmAutoInject.Create(self) do
    begin
      injectintomyself := True;
      CustomTypeScript := True;
      CustomTypeCallback := CreateCustomType;
      CustomType := ct;
      if ct.CustomTypeType = cttLuaScript then
        ScriptMode :=smLua;

      assemblescreen.Lines.Text := CustomType.script;

      Show;
    end;

  end;
end;


procedure TMainForm.miDefineNewCustomTypeLuaClick(Sender: TObject);
var
  fbn, n: string;
begin
  n := 'Custom LUA type';
  fbn := 'customvaluetype';
  if customTypes.Count > 0 then
  begin
    n := n + ' ' + IntToStr(customtypes.Count + 1);
    fbn := fbn + IntToStr(customtypes.Count + 1);
  end;

  with TfrmAutoInject.Create(self) do
  begin
    injectintomyself := True;
    CustomTypeScript := True;
    CustomTypeCallback := CreateCustomType;
    CustomType := nil;
    ScriptMode:= smLua;

    with assemblescreen.Lines do
    begin
      Add('--Note: keep the function base name unique.');
      Add('typename="' + n + '" --shown as the typename in ce');
      Add('bytecount=4  --number of bytes of this type');
      Add('functionbasename="' + fbn + '"');
      Add('');
      Add('function ' + fbn + '_bytestovalue(b1,b2,b3,b4,address)');
      Add('--Add extra byte parameters as required');
      Add('return 123');
      Add('');
      Add('end');
      Add('');
      Add('function ' + fbn + '_valuetobytes(i,address)');
      Add('');
      Add('--return the bytes to write (usually only used when you change the value)');
      Add('return 0,0,0,0');
      Add('');
      Add('end');
      Add('return typename,bytecount,functionbasename');
    end;
    Show;

  end;
end;


procedure TMainForm.miDefineNewCustomTypeClick(Sender: TObject);
var
  fbn, n: string;
begin
  n := 'Custom Type Name';
  if customTypes.Count > 0 then
    n := n + ' ' + IntToStr(customtypes.Count + 1);

  with TfrmAutoInject.Create(self) do
  begin
    injectintomyself := True;
    CustomTypeScript := True;
    CustomTypeCallback := CreateCustomType;
    CustomType := nil;

    with assemblescreen.Lines do
    begin
      Add('alloc(ConvertRoutine,1024)');
      Add('alloc(ConvertBackRoutine,1024)');
      Add('alloc(TypeName,256)');
      Add('alloc(ByteSize,4)');
      Add('alloc(UsesFloat,1)');
      Add('alloc(CallMethod,1)');
      Add('');
      Add('TypeName:');
      Add('db ''' + n + ''',0');
      Add('');
      Add('ByteSize:');
      Add('dd 4');
      Add('');
      Add('UsesFloat:');
      Add('db 0 //Change to 1 if this custom type should be treated as a float');
      Add('');
      Add('CallMethod:');
      Add('db 1 //Remove or change to 0 for legacy call mechanism');
      Add('');
      Add('//The convert routine should hold a routine that converts the data to an integer (in eax)');
      Add('//function declared as: cdecl int ConvertRoutine(unsigned char *input, PTR_UINT address);');
      Add('//Note: Keep in mind that this routine can be called by multiple threads at the same time.');
      Add('ConvertRoutine:');
      Add('//jmp dllname.functionname');
      add('[64-bit]');
      Add('//or manual:');
      Add('//parameters: (64-bit)');
      Add('//rcx=address of input');
      Add('//rdx=address');
      Add('mov eax,[rcx] //eax now contains the bytes ''input'' pointed to');
      Add('');
      Add('ret');
      add('[/64-bit]');
      add('');
      add('[32-bit]');
      Add('//jmp dllname.functionname');
      Add('//or manual:');
      Add('//parameters: (32-bit)'); //[esp]=return [esp+4]=input
      Add('push ebp');  //[esp]=ebp , [esp+4]=return [esp+8]=input
      Add('mov ebp,esp');  //[ebp]=ebp , [esp+4]=return [esp+8]=input
      Add('//[ebp+8]=address of input');
      Add('//[ebp+c]=address');
      Add('//example:');
      Add('mov eax,[ebp+8] //place the address that contains the bytes into eax');
      Add('mov eax,[eax] //place the bytes into eax so it''s handled as a normal 4 byte value');
      Add('');
      Add('pop ebp');
      Add('ret');
      add('[/32-bit]');

      Add('');
      Add('//The convert back routine should hold a routine that converts the given integer back to a row of bytes (e.g when the user wats to write a new value)');
      Add('//function declared as: cdecl void ConvertBackRoutine(int i, PTR_UINT address, unsigned char *output);');
      Add('ConvertBackRoutine:');
      Add('//jmp dllname.functionname');
      Add('//or manual:');
      Add('[64-bit]');
      Add('//parameters: (64-bit)');
      Add('//ecx=input');
      Add('//rdx=address');
      Add('//r8=address of output');
      Add('//example:');
      Add('mov [r8],ecx //place the integer at the 4 bytes pointed to by r8');
      Add('');
      Add('ret');
      Add('[/64-bit]');
      add('');
      Add('[32-bit]');
      Add('//parameters: (32-bit)'); //[esp]=return [esp+4]=input
      Add('push ebp');  //[esp]=ebp , [esp+4]=return [esp+8]=input
      Add('mov ebp,esp');  //[ebp]=ebp , [esp+4]=return [esp+8]=input
      Add('//[ebp+8]=input');
      Add('//[ebp+c]=address');
      Add('//[ebp+10]=address of output');
      Add('//example:');
      Add('push eax');
      Add('push ebx');
      Add('mov eax,[ebp+8] //load the value into eax');
      Add('mov ebx,[ebp+10] //load the output address into ebx');
      Add('mov [ebx],eax //write the value into the address');
      Add('pop ebx');
      Add('pop eax');

      Add('');
      Add('pop ebp');
      Add('ret');
      add('[/32-bit]');
      Add('');
    end;

    Show;
  end;

end;

procedure TMainForm.miRecursiveSetValueClick(Sender: TObject);
begin
  miRecursiveSetValue.Checked := not miRecursiveSetValue.Checked;

  if addresslist.selectedRecord <> nil then
  begin
    if miRecursiveSetValue.Checked then
      addresslist.selectedRecord.options :=
        addresslist.selectedRecord.options + [moRecursiveSetValue]
    else
      addresslist.selectedRecord.options :=
        addresslist.selectedRecord.options - [moRecursiveSetValue];
  end;
end;

procedure TMainForm.miRenameTabClick(Sender: TObject);
var
  s: string;
begin
  s := scantablist.TabText[scantablist.SelectedTab];
  if InputQuery(rsCheatEngine, rsWhatWillBeTheNewNameForThisTab, s) then
    scantablist.TabText[scantablist.SelectedTab] := s;
end;



procedure TMainForm.SaveCurrentState(scanstate: PScanState; skipuservalues: boolean=false);
begin
  //save the current state
  scanstate.alignsizechangedbyuser := alignsizechangedbyuser;

  scanstate.compareToSavedScan := comparetosavedscan;
  scanstate.currentlySelectedSavedResultname := currentlySelectedSavedResultname;
  //I love long variable names

  scanstate.lblcompareToSavedScan.Caption := lblcompareToSavedScan.Caption;
  scanstate.lblcompareToSavedScan.Visible := lblcompareToSavedScan.Visible;
  scanstate.lblcompareToSavedScan.left := lblcompareToSavedScan.left;


  if not skipuservalues then
  begin
    scanstate.FromAddress.Text := fromaddress.Text;
    scanstate.ToAddress.Text := toaddress.Text;
  end;


  scanstate.cbfastscan.Checked := cbFastScan.Checked;

  if not skipuservalues then
    scanstate.edtAlignment.Text := edtAlignment.Text;

  scanstate.edtAlignment.enabled:=edtAlignment.enabled;

  scanstate.rbFsmAligned.checked:=rbFsmAligned.checked;

  if not skipuservalues then
    scanstate.scanvalue.Text := scanvalue.Text;

  scanstate.scanvalue.Visible := scanvalue.Visible;

  if scanvalue2 <> nil then
  begin
    scanstate.scanvalue2.exists := True;
    if not skipuservalues then
      scanstate.scanvalue2.Text := scanvalue2.Text;
  end
  else
    scanstate.scanvalue2.exists := False;

  scanstate.scantype.options := scantype.Items.Text;
  scanstate.scantype.Enabled := scantype.Enabled;
  scanstate.scantype.ItemIndex := scantype.ItemIndex;
  scanstate.scantype.dropdowncount := scantype.DropDownCount;

  //scanstate.vartype.options := vartype.Items;
  scanstate.vartype.Enabled := vartype.Enabled;
  scanstate.vartype.ItemIndex := vartype.ItemIndex;


  scanstate.firstscanstate.Caption := btnNewScan.Caption;
  scanstate.firstscanstate.Enabled := btnNewScan.Enabled;
  scanstate.nextscanstate.Enabled := btnNextScan.Enabled;


  scanstate.gbScanOptionsEnabled := gbScanOptions.Enabled;

  scanstate.floatpanel.Visible := pnlfloat.Visible;
  scanstate.floatpanel.rounded := rt1.Checked;
  scanstate.floatpanel.roundedextreme := rt2.Checked;
  scanstate.floatpanel.truncated := rt3.Checked;


  scanstate.rbbit.Visible := rbbit.Visible;
  scanstate.rbbit.Enabled := rbbit.Enabled;
  scanstate.rbbit.Checked := rbbit.Checked;

  scanstate.rbdec.Visible := rbdec.Visible;
  scanstate.rbdec.Enabled := rbdec.Enabled;
  scanstate.rbdec.Checked := rbdec.Checked;

  scanstate.cbHexadecimal.Visible := cbHexadecimal.Visible;
  scanstate.cbHexadecimal.Checked := cbHexadecimal.Checked;
  scanstate.cbHexadecimal.Enabled := cbHexadecimal.Enabled;

  scanstate.cbunicode.Visible := cbunicode.visible;
  scanstate.cbunicode.checked := cbunicode.checked;
  scanstate.cbcodepage.Visible := cbcodepage.visible;
  scanstate.cbcodepage.checked := cbcodepage.checked;
  scanstate.cbCaseSensitive.Visible := cbCaseSensitive.visible;
  scanstate.cbCaseSensitive.checked := cbCaseSensitive.checked;


  if cbpercentage <> nil then
  begin
    scanstate.cbpercentage.exists := False;
    scanstate.cbpercentage.Checked := cbpercentage.Checked;
  end
  else
    scanstate.cbpercentage.exists := False;

  scanstate.btnFirst.tag := btnFirst.tag;
  scanstate.foundlist3.ItemIndex := foundlist3.ItemIndex;

  scanstate.foundlistDisplayOverride:=foundlistDisplayOverride;

  scanstate.cbNot.Checked:=cbNot.checked;
  scanstate.cbfloatSimple.Checked:=cbFloatSimple.checked


{
  if foundlist3.TopItem<>nil then
    scanstate.foundlist3.topitemindex:=foundlist3.topitem.Index
  else
    scanstate.foundlist3.topitemindex:=-1;    }
end;

procedure TMainForm.SetupInitialScanTabState(scanstate: PScanState;
  IsFirstEntry: boolean);
begin
  ZeroMemory(scanstate, sizeof(TScanState));

  if IsFirstEntry then
  begin
    scanstate.memscan := memscan;
    scanstate.foundlist := foundlist;
  end
  else
  begin
    scanstate.memscan := tmemscan.Create(ProgressBar);
    scanstate.memscan.GuiScanner:=true;
    scanstate.memscan.OnGuiUpdate:=MemscanGuiUpdate;
    scanstate.foundlist := TFoundList.Create(foundlist3, scanstate.memscan);    //build again
    scanstate.memscan.OnInitialScanDone:=memscan.OnInitialScanDone;
    scanstate.memscan.OnScanDone:=memscan.OnScanDone;
  end;

  savecurrentstate(scanstate);

  //initial scans don't have a previous scan
  scanstate.lblcompareToSavedScan.Visible := False;
  scanstate.compareToSavedScan := False;

end;

procedure TMainForm.ScanTabListTabChange(Sender: TObject; oldselection: integer);
var
  oldstate, newstate: PScanState;
begin
  oldstate := scantablist.TabData[oldselection];
  newstate := scantablist.TabData[scantablist.SelectedTab];

  savecurrentstate(oldstate);

  //load the new state
  if newstate <> nil then
  begin
    //load
    mainform.BeginFormUpdate;

    foundlistDisplayOverride:=0;

    scantype.OnChange := nil;
    vartype.onchange := nil;
    rbbit.OnClick := nil;
    rbdec.Onclick := nil;
    cbHexadecimal.OnClick := nil;

    if PreviousResults<>nil then
      freeandnil(PreviousResults);


    scanvalue.Text := newstate.scanvalue.Text;
    scanvalue.Visible := newstate.scanvalue.Visible;

    if newstate.scanvalue2.exists then
    begin
      CreateScanValue2;
      scanvalue2.Text := newstate.scanvalue2.Text;
    end
    else
    begin
      //destroy if it exists
      DestroyScanValue2;
    end;

    alignsizechangedbyuser := newstate.alignsizechangedbyuser;
    comparetosavedscan := newstate.compareToSavedScan;
    currentlySelectedSavedResultname := newstate.currentlySelectedSavedResultname;
    //I love long variable names

    lblcompareToSavedScan.Caption := newstate.lblcompareToSavedScan.Caption;
    lblcompareToSavedScan.Visible := newstate.lblcompareToSavedScan.Visible;
    lblcompareToSavedScan.left := newstate.lblcompareToSavedScan.left;



    scantype.items.Text := newstate.scantype.options;
    scantype.Enabled := newstate.scantype.Enabled;
    scantype.ItemIndex := newstate.scantype.ItemIndex;
    scantype.DropDownCount := newstate.scantype.dropdowncount;

   // vartype.items.Text := newstate.vartype.options;
    vartype.Enabled := newstate.vartype.Enabled;
    vartype.ItemIndex := newstate.vartype.ItemIndex;


    btnNewScan.Caption := newstate.firstscanstate.Caption;
    btnNewScan.Enabled := newstate.firstscanstate.Enabled;

    btnNextScan.Enabled := newstate.nextscanstate.Enabled;

    setGbScanOptionsEnabled(newstate.gbScanOptionsEnabled);

    cbFastScan.OnChange:=nil;
    cbFastScan.Checked := newstate.cbfastscan.Checked;
    cbFastScan.OnChange:=cbFastScanChange;

    edtAlignment.Text := newstate.edtAlignment.Text;
    edtAlignment.Enabled:=newstate.edtAlignment.enabled;
    rbFsmAligned.checked:=newstate.rbFsmAligned.checked;
    if rbFsmAligned.checked=false then
      rbfsmLastDigts.checked:=true;


    pnlfloat.Visible := newstate.floatpanel.Visible;
    rt1.Checked := newstate.floatpanel.rounded;
    rt2.Checked := newstate.floatpanel.roundedextreme;
    rt3.Checked := newstate.floatpanel.truncated;





    rbbit.Visible := newstate.rbbit.Visible;
    rbbit.Enabled := newstate.rbbit.Enabled;
    rbbit.Checked := newstate.rbbit.Checked;

    rbdec.Visible := newstate.rbdec.Visible;
    rbdec.Enabled := newstate.rbdec.Enabled;
    rbdec.Checked := newstate.rbdec.Checked;

    cbHexadecimal.Visible := newstate.cbHexadecimal.Visible;
    cbHexadecimal.Checked := newstate.cbHexadecimal.Checked;
    cbHexadecimal.Enabled := newstate.cbHexadecimal.Enabled;

    if newstate.cbpercentage.exists then
    begin
      CreateCbPercentage;
      cbpercentage.Checked := newstate.cbpercentage.Checked;
    end
    else
      DestroyCbPercentage;

    btnFirst.tag := newstate.btnFirst.tag;

    scantype.OnChange := ScanTypeChange;
    VarType.OnChange := VarTypeChange;
    rbbit.OnClick := rbBitClick;
    rbdec.Onclick := rbDecClick;
    cbHexadecimal.OnClick := cbHexadecimalClick;

    mainform.EndFormUpdate;


    foundlist3.beginupdate;


    foundlist.Deinitialize;

    memscan := newstate.memscan;
    foundlist := newstate.foundlist;


    if VarType.itemindex=10 then
    begin
      createGroupConfigButton;
      scantype.Visible:=false;
      lblscantype.Visible:=false;
    end
    else
    begin
      destroyGroupConfigButton;
      scantype.Visible:=true;
      lblscantype.Visible:=true;
    end;

    UpdateScanType;



    foundcount := foundlist.Initialize(getvartype, memscan.customtype);


    try
      PreviousResults:=TSavedScanHandler.create(memscan.getScanFolder, currentlySelectedSavedResultname);

      PreviousResults.AllowNotFound:=true;
      PreviousResults.AllowRandomAccess:=true;
    except
      PreviousResults:=nil;
    end;


    foundlist3.endupdate;


    cbunicode.Visible := newstate.cbunicode.visible;
    cbunicode.checked := newstate.cbunicode.checked;
    cbCodePage.Visible := newstate.cbCodePage.visible;
    cbCodePage.checked := newstate.cbCodePage.checked;
    cbCaseSensitive.Visible := newstate.cbCaseSensitive.visible;
    cbCaseSensitive.checked := newstate.cbCaseSensitive.checked;


    if newstate.foundlist3.ItemIndex=-1 then
      newstate.foundlist3.ItemIndex:=0;

    if (newstate.foundlist3.ItemIndex < foundcount) then
    begin
      foundlist3.ItemIndex := newstate.foundlist3.ItemIndex;
      foundlist3.Items[newstate.foundlist3.ItemIndex].Selected := True;
      foundlist3.Items[newstate.foundlist3.ItemIndex].MakeVisible(False);
      foundlist3.Items[newstate.foundlist3.ItemIndex].Top := 0;
    end;

    foundlistDisplayOverride:=newstate.foundlistDisplayOverride;

    cbNot.Checked:=newstate.cbNot.checked;
    cbFloatSimple.checked:=newstate.cbfloatSimple.Checked;

    UpdateFloatRelatedPositions;

    //    foundlist3.TopItem:=foundlist3.items[newstate.foundlist.itemindex];
  end;
  //else leave empty
end;

procedure TMainForm.miAddTabClick(Sender: TObject);
var
  i: integer;
  c: array of tcontrol;
  foundlistheightdiff: integer;
  newstate: PScanState;

  scantabtopcontrol: TControl;
begin
  if scantablist = nil then
  begin
    foundlistheightdiff := btnMemoryView.top - (foundlist3.top + foundlist3.Height);

    scantablist := TTablist.Create(self);
    scantablist.Name:='ScantabList';

    scantabtopcontrol:=panel7;
    if scantabtopcontrol.top+scantabtopcontrol.Height<ProgressBar.Top+ProgressBar.Height then
      scantabtopcontrol:=ProgressBar;

    scantablist.AnchorSideTop.Control:=scantabtopcontrol;
    scantablist.AnchorSideTop.Side:=asrBottom;

    scantablist.AnchorSideLeft.Control:=panel5;
    scantablist.AnchorSideLeft.Side:=asrLeft;

    scantablist.AnchorSideRight.Control:=logopanel;
    if scantabtopcontrol.Top+scantabtopcontrol.Height<(logopanel.Height-4) then
      scantablist.AnchorSideRight.Side:=asrLeft
    else
      scantablist.AnchorSideRight.Side:=asrRight; //it can go under the logo

    scantablist.BorderSpacing.Top:=4;


    scantablist.PopupMenu := pmTablist;
    scantablist.color := panel5.Color;
    scantablist.Parent:=panel5;
    scantablist.Anchors := [akTop, akLeft, akRight];

    scantablist.Height := scantablist.Canvas.TextHeight('WwJjDdQq')+4;

    label6.AnchorSideTop.Control:=scantablist;
    lblcompareToSavedScan.AnchorSideTop.Control:=scantablist;


    i := scantablist.AddTab(rsScan + ' 1'); //original scan

    getmem(newstate, sizeof(TScanState));
    SetupInitialScanTabState(newstate, True);
    scantablist.TabData[i] := newstate;

    i := scantablist.AddTab(rsScan + ' 2'); //first new scan
    getmem(newstate, sizeof(TScanState));
    SetupInitialScanTabState(newstate, False);
    scantablist.TabData[i] := newstate;

    scantablist.OnTabChange := ScanTabListTabChange;
    scantablist.SelectedTab := i;


    tabcounter := 3;


    scantablist.Color := clBtnFace;
    scantablist.Brush.Color := clBtnFace;



    foundlist3.Height := btnMemoryView.top - foundlist3.top - foundlistheightdiff;

    scantype.Top:=scantype.top+scantablist.Height+4;
  end
  else
  begin
    i := scantablist.addtab(rsScan + ' ' + IntToStr(tabcounter));
    getmem(newstate, sizeof(TScanState));
    SetupInitialScanTabState(newstate, False);
    scantablist.TabData[i] := newstate;

    scantablist.SelectedTab := i;
    Inc(tabcounter);
  end;

  if btnNextScan.Enabled then
    btnNewScan.click;

end;

procedure TMainForm.miCloseTabClick(Sender: TObject);
var
  oldscanstate: PScanState;
  oldindex: integer;
begin
  if (scantablist <> nil) and (scantablist.Count > 1) then
  begin
    //since rightclicking a tab selects it, delete the currently selected tab
    oldindex := scantablist.SelectedTab;
    oldscanstate := scantablist.TabData[scantablist.SelectedTab];

    //switch the currently selected tab to the right one if possible, else the lef tone
    if oldindex < scantablist.Count - 1 then
      scantablist.SelectedTab := oldindex + 1
    else
      scantablist.SelectedTab := oldindex - 1;

    scantablist.RemoveTab(oldindex);

    //now we can delete the tabdata
    freeandnil(oldscanstate.foundlist);
    freeandnil(oldscanstate.memscan);
    freememandnil(oldscanstate);
  end;
end;

procedure TMainForm.UpdateFloatRelatedPositions;
begin
  if pnlFloat.visible then
  begin
 //   cbFloatSimple.Top:=pnlFloat.Top+pnlFloat.Height;
   // cbUnrandomizer.top:=cbFloatSimple.Top+cbFloatSimple.Height;
    cbFloatSimple.visible:=true;
  end
  else
  begin
 //   cbFloatSimple.top:=pnlFloat.top;
   // cbUnrandomizer.top:=gbScanOptions.top;

    cbFloatSimple.visible:=(getVarType in [vtSingle, vtDouble, vtAll]) and (GetScanType<>soUnknownValue);
  end;

//  if cbpercentage<>nil then
//    cbFloatSimple.Top:=cbpercentage.top+cbpercentage.Height;

end;

procedure TMainForm.miFreezeNegativeClick(Sender: TObject);
begin
  addresslist.ActivateSelected(ftAllowDecrease);
end;

procedure TMainForm.miFreezePositiveClick(Sender: TObject);
begin
  addresslist.ActivateSelected(ftAllowIncrease);
end;

procedure TMainForm.miSaveScanresultsClick(Sender: TObject);
var
  n: string;
begin
  if memscan.nextscanCount > 0 then
  begin
    n := rsScanresult + ' ' + IntToStr(memscan.nextscanCount + 1);
    if inputquery(rsSaveScanResults, rsWhatNameDoYouWantToGiveToTheseScanresults, n) then
    begin
      memscan.saveresults(n);
      UpdateScanType;
    end;
  end;
end;

procedure TMainForm.miShowAsBinaryClick(Sender: TObject);
begin
  if (addresslist.selectedrecord <> nil) and
    (addresslist.selectedrecord.vartype = vtbinary) then
    addresslist.selectedrecord.extra.bitData.showasbinary := not
      addresslist.selectedrecord.extra.bitData.showasbinary;
end;

procedure TMainForm.miUndoValueClick(Sender: TObject);
begin
  if (addresslist.selectedrecord <> nil) and (addresslist.selectedrecord.canUndo) then
    addresslist.selectedrecord.UndoSetValue;
end;

procedure TMainForm.miWireframeClick(Sender: TObject);
begin
  safed3dhook;
  if d3dhook<>nil then
    d3dhook.setWireframeMode(miWireframe.Checked);

  updated3dgui;
end;

procedure TMainForm.miZbufferClick(Sender: TObject);
begin
  safed3dhook;
  if d3dhook<>nil then
    d3dhook.setDisabledZBuffer(miZbuffer.Checked);

  updated3dgui;
end;

procedure TMainForm.miZeroTerminateClick(Sender: TObject);
begin
  if (addresslist.selectedRecord <> nil) and
    (addresslist.selectedRecord.VarType = vtString) then
    addresslist.selectedRecord.Extra.stringData.ZeroTerminate := not
      addresslist.selectedRecord.Extra.stringData.ZeroTerminate;
end;

procedure TMainForm.ools1Click(Sender: TObject);
begin

end;

procedure TMainForm.Panel1Click(Sender: TObject);
begin

end;


procedure TMainForm.Panel5Resize(Sender: TObject);
var
  widthleft,w,aw: integer;
begin
 // scanvalue2.width:=(((panel5.width-5)-scanvalue.left+((andlabel.width+10) div 2)) div 2);
  w:=(panel5.clientwidth-scanvalue.left)-5 ;
  aw:=andlabel.width+8;
  scanvalue2.width:=(w div 2) - (aw div 2);

  {cbSpeedhack.left := panel5.clientwidth - cbspeedhack.Width;
  cbUnrandomizer.left := cbspeedhack.left;
  gbScanOptions.Left := cbUnrandomizer.left - gbScanOptions.Width - 3;

  speedbutton3.top := foundlist3.top + foundlist3.Height - speedbutton3.Height;
  speedbutton3.left := foundlist3.left + foundlist3.Width + 2;


  ScanText.left := scanvalue.left; //lazarus rev  25348 32-bit fix
  if ScanText2 <> nil then
    scantext2.left := scanvalue2.Left;

  if andlabel <> nil then
    andlabel.Left := scanvalue2.Left - 20;


  lblcompareToSavedScan.left :=
    btnNewScan.left + ((((btnNextScan.left + btnNextScan.Width) - btnNewScan.left) div 2) -
    (lblcompareToSavedScan.Width div 2));

  if cbpercentage <> nil then
    cbpercentage.left := scantype.left + scantype.Width + 5;

  }

  //resize the foundlist columns. Do NOT do this in the onresize of the foundlist
  widthleft:=foundlist3.clientwidth-foundlist3.Columns[0].Width;

  if miShowPreviousValue.checked then
  begin
    if widthleft>0 then
      w:=widthleft div 2
    else
      w:=1;

    foundlist3.columns[1].width:=TWidth(w);
    foundlist3.columns[2].width:=foundlist3.columns[1].width;
  end
  else
  begin
    foundlist3.columns[1].width:=widthleft;
  end;

end;

procedure TMainForm.pmTablistPopup(Sender: TObject);
var
  x, y: integer;
begin
  if scantablist <> nil then //should always be true
  begin
    x := scantablist.ScreenToClient(mouse.cursorpos).x;
    y := scantablist.ScreenToClient(mouse.cursorpos).y;
    miCloseTab.Visible := scantablist.GetTabIndexAt(x, y) <> -1;
    miTablistSeperator.Visible := miCloseTab.Visible;
    miRenameTab.Visible := miCloseTab.Visible;
  end;
end;

procedure TMainForm.pmValueTypePopup(Sender: TObject);
begin
  miEditCustomType.Visible := (vartype.ItemIndex <> -1) and
    (vartype.items.objects[vartype.ItemIndex] <> nil);
  miDeleteCustomType.Visible := miEditCustomType.Visible;

  miShowCustomTypeDebug.visible:=miEditCustomType.Visible and (GetKeyState(VK_SHIFT) and 32768=32768);

end;

procedure TMainForm.miShowCustomTypeDebugClick(Sender: TObject);
var ct: TCustomType;
begin
  ct:=TCustomType(vartype.items.objects[vartype.ItemIndex]);
  ct.showDebugInfo;
end;

procedure TMainForm.miShowPreviousValueClick(Sender: TObject);
var reg: Tregistry;
begin
  //Show/Hide the previousValue column
  //

  if miShowPreviousValue.checked then
  begin
    foundlist3.column[1].Width:=foundlist3.column[1].width div 2;
    foundlist3.Column[2].visible:=true;
  end
  else
  begin
    foundlist3.Column[2].visible:=false;
  end;
  //foundlist3.AutoWidthLastColumn:=false;
  //foundlist3.AutoWidthLastColumn:=true;

  cereg.writeBool('Show previous value column', miShowPreviousValue.checked);
end;




procedure TMainForm.aprilfoolsscan;
begin

  if aprilfools then
  begin
    if messagedlg(rsThankYouForTryingOutCheatEngineBecauseItHasExpired,
      mtInformation, [mbYes, mbNo], 0) = mrYes then
    begin
      ShowMessage(rsAprilFools);

    end
    else
    begin
      if messagedlg(rsWHATAreYouSayingYouReGoingToContinueUsingCEILLEGAL,
        mtWarning, [mbYes, mbNo], 0) = mrYes then
        ShowMessage(
          rsHrmpfBecauseIMInAGoodMoodILlLetYouGoThisTimeButDon)
      else
        ShowMessage(rsAprilFools);
    end;

    Caption := cenorm;
    aprilfools := False;
  end;
end;

procedure TMainForm.doNewScan;
begin
  if SaveFirstScanThread <> nil then //stop saving the results of the fist scan
  begin
    SaveFirstScanThread.Terminate;
    SaveFirstScanThread.WaitFor;
    FreeAndNil(SaveFirstScanThread);
  end;

  if PreviousResults<>nil then
    freeandnil(PreviousResults);

  fastscan := formsettings.cbFastscan.Checked;
  //close files in case of a bug i might have missed...

  vartype.Visible := True;

  foundcount := 0;
  foundlist.Clear;

  btnNewScan.Caption := strFirstScan;

  btnNextScan.Enabled := False;
  vartype.Enabled := True;

  scanvalue.Visible := True;
  scantext.Visible := True;

  Updatescantype;
  Scantype.ItemIndex := 0;

  //enable the memory scan groupbox
  setGbScanOptionsEnabled(True);


  VartypeChange(vartype);

  if scanvalue.Visible and scanvalue.Enabled then
  begin
    scanvalue.SetFocus;
    scanvalue.SelectAll;
  end;

  compareToSavedScan := False;
  lblcompareToSavedScan.Visible := False;

  miDisplayDefault.checked:=true;
  foundlistDisplayOverride:=0;

  if formsettings.cbPauseWhenScanningOnByDefault.checked then
    cbPauseWhileScanning.Checked:=true;

  foundlist3.Column[2].Caption:=rsPrevious;

  cbpercentage.checked:=false;
end;

procedure TMainForm.btnNewScanClick(Sender: TObject);
begin
  btnFirst.click; //now completely replaced
end;

procedure TMainForm.btnNextScanClick(Sender: TObject);
begin
  btnNext.click;
end;

procedure TMainForm.btnMemoryViewClick(Sender: TObject);
begin
  memorybrowser.Show;
end;



function TMainForm.onhelp(Command: word; Data: PtrInt; var CallHelp: boolean): boolean;
var
  wikipath: string;
  wikiurl: string;
begin
  callhelp := False;
  Result := True;

  wikipath:='https://wiki.cheatengine.org/index.php';
  wikiurl:='';

  if command = HELP_CONTEXT then
  begin
    case data of
      1:    wikiurl:='?';
      2:    wikiurl:='?title=Help_File:AboutLong';
      4:    wikiurl:='?title=Tutorials:AttachToProcess';
      11:   wikiurl:='?title=Help_File:Table_Extras';
      12:   wikiurl:='?title=Help_File:Memory_view';
      19:   wikiurl:='?title=Cheat_Engine:Lua';
      1089: wikiurl:='?title=Cheat_Engine:Auto_Assembler';
    end;


    if wikiurl='' then //no wikilink given
      HtmlHelpA(Win32WidgetSet.AppHandle, PChar(cheatenginedir + 'cheatengine.chm'), HH_HELP_CONTEXT, Data)
    else
      ShellExecute(0,'open',pchar(wikipath+wikiurl),nil,nil,SW_SHOW);

  end;


end;


procedure TMainForm.FormCreate(Sender: TObject);
var
  tokenhandle: thandle;
  tp: TTokenPrivileges;
  prev: TTokenPrivileges;

  ReturnLength: Dword;

  differentWidth: integer;
  x: array of integer;

  errormode: dword;
  minworkingsize, maxworkingsize: ptruint;
  reg: tregistry;

  PODirectory, Lang, FallbackLang: string;

  rs: TResourceStream;

  i: integer;

  dir: string;
begin
  {$if (lcl_fullversion > 1060400) and (lcl_fullversion <=1080200)}
  Foundlist3.Dragmode:=dmManual; //perhaps this gets fixed in later lcl versions, but for now, it sucks
  {$endif}

//Self.AutoAdjustLayout(lapAutoAdjustForDPI, Self.DesignTimeDPI, Screen.PixelsPerInch, Self.Width, ScaleX(Self.Width, Self.DesignTimeDPI));
//  Self.AutoAdjustLayout(lapAutoAdjustForDPI, Self.DesignTimeDPI, 200, Self.Width, ScaleX(Self.Width, Self.DesignTimeDPI));
  { font.size:=20;
  i:=FromAddress.Font.Size;
  FromAddress.Font.Size:=font.size;
  if i=0 then beep;  }

  lastAdded.vartype:=vtDword;

  miSignTable.visible:=canSignTables;


  vartype.Items.Clear;
  vartype.items.add(rs_vtBinary);
  vartype.items.add(rs_vtByte);
  vartype.items.add(rs_vtWord);
  vartype.items.add(rs_vtDword);
  vartype.items.add(rs_vtQword);
  vartype.items.add(rs_vtSingle);
  vartype.items.add(rs_vtDouble);
  vartype.items.add(rs_vtString);
  vartype.items.add(rs_vtByteArray);
  vartype.items.add(rs_vtAll);
  vartype.items.add(rs_vtGrouped);


  {$ifdef windows}
  {$ifdef cpu64}
  //lazarus bug bypass
  if WindowsVersion = wvVista then
    foundlist3.OnCustomDrawItem := nil;
  {$endif}
  {$endif}

  Set8087CW($133f);
  SetSSECSR($1f80);

  //FormDropFiles fix for win7, win8 and later (window message filter update)
  if (WindowsVersion>=wv7) and assigned(ChangeWindowMessageFilter) then
  try
   //WM_COPYGLOBALDATA = 73; MSGFLT_ADD = 1
   ChangeWindowMessageFilter(73, 1);
   ChangeWindowMessageFilter(WM_DROPFILES, 1);
  except;
  end;

  LuaFiles := TLuaFileList.Create;
  LuaForms := TList.Create;
  try
    LUA_DoScript('package.path = package.path .. [[;' + tablesdir + '\?.lua]]');
  except
    OutputDebugString('LUA_DoScript failure: package.path');
  end;

  InternalLuaFiles := TLuaFileList.Create;

  rs := TResourceStream.Create(HInstance, 'BUILDIN_ACTIVATE', RT_RCDATA);
  InternalLuaFiles.Add(TLuaFile.Create('Activate', rs));
  freeandnil(rs);


  rs := TResourceStream.Create(HInstance, 'BUILDIN_DEACTIVATE', RT_RCDATA);
  InternalLuaFiles.Add(TLuaFile.Create('Deactivate', rs));
  freeandnil(rs);


  dir:=cereg.readString('Initial tables dir');
  if dir='' then dir:=tablesdir;

  SaveDialog1.InitialDir:=dir;
  OpenDialog1.InitialDir:=dir;

  miEnableLCLDebug.Checked:=cereg.readBool('Debug');
  if miEnableLCLDebug.Checked then
    EnableLCLClick(miEnableLCLDebug);


  application.OnHelp := onhelp;



  Forms.Application.ShowButtonGlyphs := sbgNever;
  application.OnException := exceptionhandler;
  errormode := SetErrorMode(0);
  setErrorMode(errormode or SEM_FAILCRITICALERRORS or SEM_NOOPENFILEERRORBOX);


  frmLuaTableScript := TfrmAutoInject.Create(self);
  frmLuaTableScript.ScriptMode := smLua;

  frmLuaTableScript.Caption := rsLuaScriptCheatTable;
  frmLuaTableScript.New1.Visible := False;
  frmLuaTableScript.Save1.OnClick := miSave.onclick;
  frmLuaTableScript.SaveAs1.OnClick:= save1.OnClick;


  hotkeypressed := -1;



  tokenhandle := 0;

  if ownprocesshandle <> 0 then
  begin
    if OpenProcessToken(ownprocesshandle, TOKEN_QUERY or TOKEN_ADJUST_PRIVILEGES,
      tokenhandle) then
    begin
      ZeroMemory(@tp, sizeof(tp));

      if lookupPrivilegeValue(nil, 'SeDebugPrivilege', tp.Privileges[0].Luid) then
      begin
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        tp.PrivilegeCount := 1; // One privilege to set
        if not AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp),
          prev, returnlength) then
          ShowMessage(rsFailureSettingTheDebugPrivilege);
      end;

      if lookupPrivilegeValue(nil, 'SeTcbPrivilege', tp.Privileges[0].Luid) then
      begin
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        tp.PrivilegeCount := 1; // One privilege to set
        if not AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp),
          prev, returnlength) then
          ShowMessage(rsFailureSettingTheSeTcbPrivilegePrivilege);
      end;

      if lookupPrivilegeValue(nil, 'SeTcbPrivilege', tp.Privileges[0].Luid) then
      begin
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        tp.PrivilegeCount := 1; // One privilege to set
        if not AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp),
          prev, returnlength) then
          ShowMessage(rsFailureSettingTheSeTcbPrivilegePrivilege);
      end;


      ZeroMemory(@tp, sizeof(tp));
      if lookupPrivilegeValue(nil, SE_LOAD_DRIVER_NAME, tp.Privileges[0].Luid) then
      begin
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        tp.PrivilegeCount := 1; // One privilege to set
        if not AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp),
          prev, returnlength) then
          ShowMessage(rsFailureSettingTheLoadDriverPrivilege);
      end;




      if GetSystemType >= 7 then
      begin
        ZeroMemory(@tp, sizeof(tp));
        if lookupPrivilegeValue(nil, 'SeCreateGlobalPrivilege',
          tp.Privileges[0].Luid) then
        begin
          tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
          tp.PrivilegeCount := 1; // One privilege to set
          if not AdjustTokenPrivileges(tokenhandle, False, tp,
            sizeof(tp), prev, returnlength) then
            ShowMessage(rsFailureSettingTheCreateGlobalPrivilege);
        end;



        {$ifdef cpu64}
        ZeroMemory(@tp, sizeof(tp));
        ZeroMemory(@prev, sizeof(prev));

        if lookupPrivilegeValue(nil, SE_LOCK_MEMORY_NAME, tp.Privileges[0].Luid) then
        begin
          tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
          tp.PrivilegeCount := 1; // One privilege to set
          AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);

        end;

        {$endif}
      end;


      ZeroMemory(@tp, sizeof(tp));
      ZeroMemory(@prev, sizeof(prev));
      if lookupPrivilegeValue(nil, 'SeIncreaseWorkingSetPrivilege',
        tp.Privileges[0].Luid) then
      begin
        tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
        tp.PrivilegeCount := 1; // One privilege to set
        AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
      end;

    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeSecurityPrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;


    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeTakeOwnershipPrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeManageVolumePrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeBackupPrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeCreatePagefilePrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeShutdownPrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;

    ZeroMemory(@tp, sizeof(tp));
    ZeroMemory(@prev, sizeof(prev));
    if lookupPrivilegeValue(nil, 'SeRestorePrivilege', tp.Privileges[0].Luid) then
    begin
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      tp.PrivilegeCount := 1; // One privilege to set
      AdjustTokenPrivileges(tokenhandle, False, tp, sizeof(tp), prev, returnlength);
    end;


    if GetProcessWorkingSetSize(ownprocesshandle, minworkingsize, maxworkingsize) then
      SetProcessWorkingSetSize(ownprocesshandle, 16 * 1024 * 1024, 64 * 1024 * 1024);

  end;


  tempbitmap := TBitmap.Create;

  scanvalue.Text := '';

  {$ifdef cpu64}
  fromaddress.MaxLength := 16;
  toaddress.MaxLength := 16;
  {$else}
  fromaddress.MaxLength := 8;
  toaddress.MaxLength := 8;
  {$endif}

  miResetRange.click;

  isbit := False;

  old8087CW := Get8087CW;
  Set8087CW($133f);
  SetSSECSR($1f80);



  debugproc := False;

  //get current screen resolution (when switching back for debug)
  originalwidth := screen.Width;
  originalheight := screen.Height;

  Memimage := TMemorystream.Create;

  oldwidth := screen.Width;
  oldheight := screen.Height;

  ProcessHandler.ProcessHandle := 0;

  logo.Hint := strClickToGoHome;

  logo.ShowHint := True;

  newaddress := 0;

  VarType.ItemIndex := 3;
  oldvartype := 3;

  UpdateScantype;
  ScanType.ItemIndex := 0;

  btnNewScan.Caption := strFirstScan;
  hookedin := False;

  //allignment fixes for some window style's that mess up with thick borders (like vista)
  differentWidth := logopanel.left - (clientwidth - logopanel.Width);
  btnAddAddressManually.Left := clientwidth - btnAddAddressManually.Width;
  commentbutton.left := clientwidth - commentbutton.Width;
  logopanel.left := clientwidth - logopanel.Width;
  ProgressBar.Width := ProgressBar.Width - differentwidth;
  undoscan.left := undoscan.left - differentwidth;

  //create object for the auto attach list
  autoattachlist := TStringList.Create;
  autoattachlist.CaseSensitive := False; //set it up as not case sensitive
  autoattachlist.Delimiter := ';';

  extraautoattachlist := TStringList.Create;
  extraautoattachlist.CaseSensitive := False; //set it up as not case sensitive
  extraautoattachlist.Delimiter := ';';
  extraautoattachlist.Duplicates := dupIgnore;

  randomize;



{$ifdef ceasinjectabledll}
  //panel7.Visible:=false;
  sbOpenProcess.Enabled := False;
  processid := getcurrentprocessid;
  processhandle := getcurrentprocess;
  enableGui;
  processlabel.Caption := Inttohex(processid, 8) + ' : ' + rsCurrentProcess;
{$endif}



  oldhandle := mainform.handle;

  addresslist := TAddresslist.Create(self);
  addresslist.Width := 500;
  addresslist.Height := 150;
  addresslist.top := 50;
  addresslist.parent := panel1;
  addresslist.PopupMenu := popupmenu2;
  addresslist.OnDropByListview := AddresslistDropByListview;
  addresslist.OnAutoAssemblerEdit := AddressListAutoAssemblerEdit;
  addresslist.Align := alClient;
  addresslist.AutoSize:=true;


  symhandler.loadCommonModuleList;

  setlength(x, 7);
  if loadformposition(self, x) then
  begin
    autosize:=false;
    addresslist.headers.Sections[0].Width := x[0];
    addresslist.headers.Sections[1].Width := x[1];
    addresslist.headers.Sections[2].Width := x[2];
    addresslist.headers.Sections[3].Width := x[3];
    addresslist.headers.Sections[4].Width := x[4];
    panel5.Height := x[5];
    foundlist3.columns[0].Width := x[6];
  end;

  mainform:=self;



  pluginhandler := TPluginhandler.Create;

  //custom types
  LoadCustomTypesFromRegistry;


  XInputMessages(true);

  luaclass_newClass(luavm, self);
  lua_setglobal(luavm,'MainForm');

  luaclass_newClass(luavm, addresslist);
  lua_setglobal(luavm,'AddressList');

  miEnableLCLDebug.checked:=cereg.readBool('Debug');
  allocsAddToUnexpectedExceptionList:=cereg.readBool('Add Allocated Memory As Watched');
  case cereg.readInteger('Unexpected Breakpoint Behaviour',0) of
    0: UnexpectedExceptionAction:=ueaIgnore;
    1: UnexpectedExceptionAction:=ueaBreak;
    2: UnexpectedExceptionAction:=ueaBreakIfInRegion;
  end;



end;

procedure TMainForm.ChangedHandle(Sender: TObject);
begin
 // memscan.setScanDoneCallback(mainform.handle, wm_scandone);

  //reset the hotkeys
  hotkeyTargetWindowHandleChanged(oldhandle, mainform.handle);
  oldhandle := mainform.handle;
end;

procedure TMainForm.AddressKeyPress(Sender: TObject; var Key: char);
begin
  hexadecimal(key);
end;

procedure TMainForm.FoundListDblClick(Sender: TObject);
var i: integer;
begin
  if foundList3.SelCount > 0 then
  begin
    if FoundList3.itemindex<>-1 then
      AddToRecord(FoundList3.ItemIndex)
    else
    begin
      if foundlist3.selected<>nil then
        AddToRecord(FoundList3.selected.Index)
      else
      begin
        if foundList3.Items.Count<100 then
        begin
          for i:=0 to foundList3.items.count-1 do
            if foundlist3.Items[i].Selected then
              AddToRecord(i);
        end
        else
          if foundList3.Items.Count>0 then
            AddToRecord(0);
      end;
    end;

  end;
end;

procedure TMainForm.Browsethismemoryarrea1Click(Sender: TObject);
var
  b: dword;
  s: string;
begin
  if (foundlist3.ItemIndex <> -1) then
  begin
    MemoryBrowser.memoryaddress := foundlist.GetAddress(foundlist3.ItemIndex, b, s);
    memorybrowser.Show;
  end;
end;

procedure TMainForm.tLuaGCActiveTimer(Sender: TObject);
begin
  if (lua_gc(LuaVM,LUA_GCCOUNT,0)<luagc_MinSize) then exit;

  lua_gc(LuaVM, LUA_GCCOLLECT,0);
  lua_gc(LuaVM, LUA_GCCOLLECT,0);
end;

procedure TMainForm.tLuaGCPassiveTimer(Sender: TObject);
begin
  lua_gc(LuaVM,LUA_GCSTEP,500);
end;

procedure TMainForm.UpdateTimerTimer(Sender: TObject);
begin
  try
    if addresslist <> nil then
      addresslist.Refresh;

    Inc(reinterpretcheck);
    if reinterpretcheck mod 15 = 0 then
      reinterpretaddresses;
  except
    on e: exception do
    begin
      UpdateTimer.Enabled:=false;

      MessageDlg('UpdateTimer Error:'+e.Message, mtError, [mbok],0);
    end;
  end;
end;

procedure TMainForm.FreezeTimerTimer(Sender: TObject);
var i: integer;
begin
  try
    if addresslist <> nil then
      addresslist.ApplyFreeze;
  except
    on e:exception do
    begin
      OutputDebugString('FreezeTimerTimer:'+e.Message);
    end;
  end;
end;




//vars for changevalue
var
  differentsizesanswer: boolean;
  terminatewith0answer: boolean;
  askfordifferentsizesonce: boolean;
  asked: boolean;




procedure TMainForm.Browsethismemoryregion1Click(Sender: TObject);
begin
  if addresslist.selectedrecord <> nil then
  begin
    memorybrowser.hexview.address := addresslist.selectedrecord.GetRealAddress;
    memorybrowser.Show;
  end;
end;

procedure TMainForm.Deletethisrecord1Click(Sender: TObject);
begin
  addresslist.DeleteSelected;
end;

procedure TMainForm.ScanvalueoldKeyPress(Sender: TObject; var Key: char);
begin
  checkpaste;

  if key = chr(13) then
  begin
    if btnNextScan.Enabled then
      btnNextScan.Click
    else
      btnNewScan.Click;

    key := #0;
    exit;
  end;
end;



procedure TMainForm.Calculatenewvaluepart21Click(Sender: TObject);
var
  newaddress: ptrUint;
  calculate: int64;
  i, j, err: integer;
  selectedi: integer;

  firstispointer: boolean;
  re: string;
  ok: boolean;

  res: integer;

  sel: TMemoryRecord;
  tempaddress: ptrUint;

  updatelist: Tlist;
  tn: TTreenode;
  minlevel: integer; //if the scan for entries goes below this, it means it got outside the current node

begin
  if (addresslist.Count = 0) or (addresslist.SelCount=0) then
    exit;


  res := -1;

  //first find out how many where selected.
  i := 0;
  selectedi := addresslist.SelCount;

  firstispointer := False;

  sel := addresslist.selectedRecord;
  if sel = nil then
    sel := addresslist[0];


  if sel.IsPointer then
    if messagedlg(strSelectedAddressIsAPointer, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
      exit
    else
      firstispointer := True;


  if selectedi > 1 then
  begin
    //see if there are (other) pointers selected
    for i := 0 to addresslist.Count - 1 do
      if (addresslist[i] <> sel) and (addresslist[i].isselected) and
        (addresslist[i].IsPointer) then
      begin
        if firstispointer then
          re := strMorePointers
        else
          re := strMorePointers2;

        break;
      end;
  end
  else
  begin
    //all addresses
    for i := 0 to addresslist.Count - 1 do
      if (addresslist[i] <> sel) and (addresslist[i].IsPointer) then
      begin
        if firstispointer then
          re := strMorePointers
        else
          re := strMorePointers2;

        break;
      end;
  end;



  newaddress := sel.GetRealAddress;
  if (foundlist3.SelCount > 0) then
    newaddress := foundlist.GetAddress(foundlist3.ItemIndex);


  changeoffset := TChangeOffset.Create(self);

  changeoffset.FromAddress := sel.getBaseAddress;

  changeoffset.toAddress := NewAddress;
  if changeoffset.showmodal = mrCancel then
    exit;

  if changeoffset.error > 0 then
    raise Exception.Create(strNotAValidValue);
  calculate := changeoffset.offset;



  updatelist:=TList.create;
  if (addresslist.SelCount=1) then //recalculate all siblings and their children
  begin
    tn:=addresslist.selectedRecord.treenode.parent;
    if tn=nil then //everything
    begin
      for i:=0 to addresslist.count-1 do
        updatelist.Add(addresslist[i]);
    end
    else
    begin
      //only the siblings and children

      tn:=tn.Items[0];
      minlevel:=tn.level;

      while (tn<>nil) and (tn.level>=minlevel) do
      begin
        updatelist.add(tn.data);
        tn:=tn.GetNext;
      end;

    end;
  end
  else
  begin
    //recalculate all the selected entries
    for i:=0 to addresslist.count-1 do
      if addresslist[i].isSelected then
        updatelist.add(addresslist[i]);
  end;

  //now recalculate all the selected entries
  for i:=0 to updatelist.count-1 do
  begin
    if not tmemoryrecord(updatelist[i]).isOffset then
    begin
      tempaddress := tmemoryrecord(updatelist[i]).getBaseAddress;
      Inc(tempaddress, calculate);
      tmemoryrecord(updatelist[i]).interpretableaddress := symhandler.getNameFromAddress(tempaddress, True, True);
    end;
  end;

  freeandnil(updatelist);
  addresslist.ReinterpretAddresses;
end;

procedure TMainForm.btnAddAddressManuallyClick(Sender: TObject);
var mr: Tmemoryrecord;
begin
  mr:=addresslist.addAddressManually(lastAdded.Address, lastAdded.vartype);
  if mr<>nil then
  begin
    lastAdded.Address:=mr.interpretableaddress; //store the last used string
    lastAdded.vartype:=mr.VarType;
  end;
end;

procedure TMainForm.ScanTypeChange(Sender: TObject);
var
  old, old2: TNotifyEvent;
  s: TStringList;
  l: TfrmSelectionList;
begin
  old := scantype.OnChange;
  old2 := scantype.OnSelect;
  scantype.OnChange := nil;
  scantype.OnSelect := nil;

  try
    if (scantype.ItemIndex <> -1) then
    begin
      //currentlySelectedSavedResultname
      if (scantype.Items[scantype.ItemIndex] = strcompareToSavedScan) or
        (scantype.Items[scantype.ItemIndex] = strCompareToFirstScan) then
      begin
        s := TStringList.Create;
        try
          if (not scantypechangedbyhotkey) and (memscan.getsavedresults(s) > 1) then
          begin
            //popup a window where the user can select the scanresults
            //currentlySelectedSavedResultname
            l := TfrmSelectionList.Create(self, s);
            l.Caption := rsSavedScanResults;
            l.label1.Caption := rsSelectTheSavedScanResultFromTheListBelow;
            l.ItemIndex := 0;

            if (l.showmodal = mrOk) and (l.ItemIndex <> -1) then
            begin
              currentlySelectedSavedResultname := l.selected;
              if l.ItemIndex = 0 then
                lblcompareToSavedScan.Caption := rsComparingToF
              else
                lblcompareToSavedScan.Caption :=
                  Format(rsComparingTo, [currentlySelectedSavedResultname]);
            end
            else
            begin
              scantype.ItemIndex := lastscantype;
              exit;
            end;
          end
          else
          begin
            currentlySelectedSavedResultname := 'FIRST';
            lblcompareToSavedScan.Caption := rsComparingToF;
          end;
        finally
          freeandnil(s);
        end;

        scantype.Items[scantype.ItemIndex] := strCompareToLastScan;
        scantype.ItemIndex := lastscantype;
        compareToSavedScan := True;

        lblcompareToSavedScan.Visible := True;
        lblcompareToSavedScan.left :=
          btnNewScan.left + ((((btnNextScan.left + btnNextScan.Width) - btnNewScan.left) div 2) -
          (lblcompareToSavedScan.Width div 2));

        try
          if PreviousResults<>nil then
            freeandnil(PreviousResults);

          PreviousResults:=TSavedScanHandler.create(memscan.getScanFolder, currentlySelectedSavedResultname);
          PreviousResults.AllowNotFound:=true;
          PreviousResults.AllowRandomAccess:=true;
          foundlist3.Refresh;
        except
        end;

        foundlist3.Column[2].Caption:=rsSaved;


      end
      else
      if scantype.Items[scantype.ItemIndex] = strCompareToLastScan then
      begin
        scantype.Items[scantype.ItemIndex] := strcompareToSavedScan;
        scantype.ItemIndex := lastscantype;
        compareToSavedScan := False;
        lblcompareToSavedScan.Visible := False;

        try
          if PreviousResults<>nil then
            freeandnil(PreviousResults);

          PreviousResults:=TSavedScanHandler.create(memscan.getScanFolder, 'TMP');
          PreviousResults.AllowNotFound:=true;
          PreviousResults.AllowRandomAccess:=true;
          foundlist3.Refresh;
        except
        end;

        foundlist3.Column[2].Caption:=rsPrevious;

      end;
    end;

    updatescantype;
  finally
    scantype.OnSelect := old2;
    scantype.OnChange := old;

  end;

end;

procedure TMainForm.Value1Click(Sender: TObject);
begin
  addresslist.doValueChange;
end;

function TMainForm.convertvalue(ovartype, nvartype: integer; oldvalue: string;
  washexadecimal, ishexadecimal: boolean): string;
var
  s: string;
  oldvaluei: qword;
  oldvaluef: double absolute oldvaluei;
  oldvalueba: pbytearray;

  newvaluei: qword;
  newvaluef: double absolute newvaluei;
  newvalueba: pbytearray;

  i: integer;

  ba: TBytes;

  wasfloat: boolean;
  wasaob: boolean;

  hasbytes: boolean;
  puretext: boolean;
begin
  if ovartype = nvartype then
  begin
    Result := oldvalue;
    exit;
  end;

  Result := '';
  oldvalueba := @oldvaluei;
  newvalueba := @newvaluei;

  try
    puretext := False;
    wasfloat := False;
    wasaob := False;
    oldvaluei := 0;

    try
      case ovartype of
        0:
        begin
          //binary
          if rbdec.Checked then
            oldvaluei := StrToQWordEx(scanvalue.Text)
          else
          begin
            s := trim(oldvalue);
            for i := 1 to length(s) do
              if not (s[i] in ['0', '1']) then
                s[i] := '0';

            oldvaluei := parsers.BinToInt(s);
          end;
        end;

        1..4:
        begin
          if washexadecimal then
          begin
            oldvaluei := StrToQWordEx('$' + oldvalue);
          end
          else
            oldvaluei := StrToQWordEx(oldvalue);
        end;

        5, 6, 9:
        begin
          try
            oldvaluei := StrToInt(oldvalue);
          except
            oldvaluef := strtofloat(oldvalue);
            wasfloat := True;
          end;
        end;

        7: //generic type,  text or all
        begin
          try
            oldvaluei := StrToQWordEx(oldvalue);
          except
            oldvaluef := StrToFloat(oldvalue);
            wasfloat := True;
          end;

        end;

        8:
        begin //convert the aob to an integer if possible (max 8 bytes)
          //aob
          setlength(ba, 0);
          ConvertStringToBytes(oldvalue, washexadecimal, ba);

          oldvaluei := 0;
          for i := 0 to min(7, length(ba) - 1) do
          begin
            if ba[i] < 0 then
              ba[i] := 0;

            oldvalueba[i] := ba[i];
          end;

          wasaob := True;
        end;

        else
        begin
          if ovartype>=11 then
          begin
            if washexadecimal then
            begin
              oldvaluei := StrToQWordEx('$' + oldvalue);
            end
            else
              oldvaluei := StrToQWordEx(oldvalue);
          end;
        end;
      end;
    except
      //could not get parsed, if the target is aob then convert the text to an aob, else give up
      if nvartype = 8 then
        puretext := True
      else
      begin
        Result := '';
        exit;
      end;
    end;


    case nvartype of
      0: //binary
      begin
        if wasfloat then
          oldvaluei := trunc(oldvaluef); //convert the float to an integer

        if rbdec.Checked then
          Result := IntToStr(oldvaluei)
        else
          Result := IntToBin(oldvaluei);

      end;

      1..4: //integer or custom
      begin
        if wasfloat then
          oldvaluei := trunc(oldvaluef); //convert the float to an integer

        if ishexadecimal then
          Result := inttohex(oldvaluei, 1)
        else
          Result := IntToStr(oldvaluei);
      end;

      5..6, 9: //float
      begin
        if wasfloat then
          Result := oldvalue
        else
        begin
          if wasaob then
          begin
            try
              Result := floattostr(oldvaluef);
            except

            end;
          end
          else
            Result := IntToStr(oldvaluei);
        end;
      end;

      7:
      begin
        //text
        if wasaob then
        begin
          //convert the aob to text
          s := '';
          //ba should still be intact:
          for i := 0 to length(ba) - 1 do
          begin
            if ba[i] < 0 then
              ba[i] := 0;

            if ba[i] >= 32 then
              s := s + chr(ba[i])
            else
              s := s + '.';

            Result := s;
          end;
        end
        else
          Result := oldvalue;
      end;



      8:
      begin
        s := '';

        if (puretext) then
        begin
          for i := 1 to length(oldvalue) do
          begin
            if ishexadecimal then
              s := s + inttohex(pbyte(@oldvalue[i])^, 2) + ' '
            else
              s := s + IntToStr(pbyte(@oldvalue[i])^) + ' ';
          end;
        end
        else
        begin

          hasbytes := False;
          for i := 7 downto 0 do
          begin
            if hasbytes or (oldvalueba[i] <> 0) then
            begin
              hasBytes := True;
              if ishexadecimal then
                s := inttohex(oldvalueba[i], 2) + ' ' + s
              else
                s := IntToStr(oldvalueba[i]) + ' ' + s;
            end;
          end;

          trim(s);
        end;



        Result := s;
      end;

      else
      begin
        if nvartype>=11 then
        begin
          if wasfloat then
            oldvaluei := trunc(oldvaluef); //convert the float to an integer

          if ishexadecimal then
            Result := inttohex(oldvaluei, 1)
          else
            Result := IntToStr(oldvaluei);
        end;
      end;

    end;


  except
  end;

end;

procedure TMainForm.createGroupConfigButton;
begin
  if groupconfigbutton=nil then
  begin
    groupconfigbutton:=Tbutton.create(self);
    groupconfigbutton.Name:='groupconfigbutton';
    groupconfigbutton.caption:=rsMUGenerateGroupscanCommand;
    groupconfigbutton.parent:=scantype.Parent;
    groupconfigbutton.Left:=scantype.left;
    groupconfigbutton.top:=scantype.top;
    groupconfigbutton.width:=scantype.width;
    groupconfigbutton.height:=scantype.height;

    groupconfigbutton.AnchorSideTop.Side:=asrBottom;
    groupconfigbutton.AnchorSideTop.Control:=scanvalue;
    groupconfigbutton.BorderSpacing.Top:=scantype.top-(scanvalue.Top+scanvalue.Height);

    groupconfigbutton.AnchorSideLeft.Control:=VarType;
    groupconfigbutton.AnchorSideLeft.Side:=asrLeft;
    groupconfigbutton.AnchorSideRight.Control:=VarType;
    groupconfigbutton.AnchorSideRight.Side:=asrRight;


    groupconfigbutton.Anchors:=[akTop, akLeft, akRight];// scantype.anchors;


    vartype.AnchorSideTop.Control:=groupconfigbutton;
    panel9.AnchorSideTop.Control:=groupconfigbutton;


    groupconfigbutton.OnClick:=DoGroupconfigButtonClick;

    foundlist3.BringToFront;
  end;
end;

procedure TMainForm.destroyGroupConfigButton;
begin
  if groupconfigbutton<>nil then
  begin
    vartype.AnchorSideTop.Control:=ScanType;
    panel9.AnchorSideTop.Control:=ScanType;
    freeandnil(groupconfigbutton);
  end;
end;

procedure TMainForm.VarTypeChange(Sender: TObject);
var
  a: int64;
  pa: ^int64;
  pb: ^dword;
  b: double;
  d: single;
  i: integer;
  hexvis: boolean;
  decbitvis: boolean;
  hextext: string;
  casevis: boolean;

  oldscantype: integer;
  temp: string;

  newvartype: integer;
  unicodevis: boolean;
  tc: tbitmap;

  alignsize: integer;

  //----new convertor:
  _oldvartype, _newvartype: integer;

  washex: boolean;
  oldvalue: string;


begin
  //todo: rewrite this
  oldscantype := scantype.ItemIndex;
  newvartype := vartype.ItemIndex;

  _oldvartype := oldvartype;
  _newvartype := newvartype;
  washex := cbHexadecimal.Checked;
  oldvalue := scanvalue.Text;


  dontconvert := True;

  hexvis := True;
  unicodevis := False;

  hextext := rsHex;
  casevis := False;

  decbitvis := False;

  if rbFsmAligned.Checked and (not alignsizechangedbyuser) then
  begin
    if vartype.Items.Objects[vartype.ItemIndex] <> nil then
    begin
      //custom type is ALWAYS the decider
      if rbFsmAligned.Checked then
        edtAlignment.Text := inttohex(
          TCustomType(vartype.Items.Objects[vartype.ItemIndex]).preferedAlignment, 1);
    end
    else
    begin
      try
        case newvartype of
          0, 1, 7, 8, 9: alignsize := 1; //byte, aob, string
          2: alignsize := 2; //word
          else
            alignsize := 4; //dword, float, single, etc...
        end;

        if rbFsmAligned.Checked then
          edtAlignment.Text := inttohex(alignsize, 1);
      except
      end;
    end;

  end;




  oldvartype := vartype.ItemIndex;

  if not (oldscantype in [smallerthan, biggerthan, valueBetween,
    exact_value, Advanced_Scan]) then
    scantype.ItemIndex := 0;

  if (newvartype in [1, 2, 3, 4, 9]) or (newvartype >= 11) then //if normal or custom type
  begin
    casevis := False;
    hexvis := True;
    scanvalue.MaxLength := 0;
    cbHexadecimal.Enabled := btnNewScan.Enabled;
    //cbHexadecimal.Checked:=hexstateForIntTypes;
  end
  else
    case newvartype of
      0:
      begin //binary
        rbdec.Checked := True;
        cbHexadecimal.Checked := False;
        cbHexadecimal.Visible := False;
        decbitvis := True;
        Scantype.ItemIndex := 0;
      end;

      5:
      begin //float;
        casevis := False;

        cbHexadecimal.Checked := False;
        cbHexadecimal.Enabled := False;
        scanvalue.MaxLength := 0;
      end;

      6:
      begin //double
        hexvis := False;
        temp := scanvalue.Text;


        cbHexadecimal.Checked := False;
        cbHexadecimal.Enabled := False;
        scanvalue.MaxLength := 0;
      end;

      7:
      begin //text
        scantype.ItemIndex := 0;
        casevis := True;
        if _oldvartype<>7 then
          cbCasesensitive.Checked := True;

        cbCasesensitive.ShowHint := False;
        unicodevis := True;



        cbHexadecimal.Enabled := btnNewScan.Enabled;
        //cbHexadecimal.checked:=cbCaseSensitive.checked;
        hexvis := False;
        //hextext:='Unicode';
      end;

      8:
      begin  //array of byte
        scantype.ItemIndex := 0;
        scanvalue.MaxLength := 0;
        cbHexadecimal.Enabled := btnNewScan.Enabled;
        cbHexadecimal.Checked := True;

      end;


    end;

  cbHexadecimal.Caption := hextext;

  //group code (12/4/2011)
  scantype.visible:=newvartype<>10;
  lblscantype.visible:=newvartype<>10;

  if newvartype=10 then
  begin
    //create groupconfig button
    createGroupConfigButton;
  end
  else
  begin
    //destroy button if it exists
    destroyGroupConfigButton;
  end;


  cbHexadecimal.Visible := hexvis;
  rbdec.Visible := decbitvis;
  rbbit.Visible := decbitvis;

  pnlScanValueOptions.visible:=(cbHexadecimal.Visible or rbDec.visible or rbBit.Visible);




  cbunicode.Visible := unicodevis;
  cbCodePage.visible:= unicodevis;

  cbCaseSensitive.Visible := casevis;

  cbfastscan.Enabled := btnNewScan.Enabled and (not btnNextScan.Enabled);
  //only enabled when btnNewScan is enabled and nextscan not



  UpdateScanType;
  dontconvert := False;

  //set the old vartype
  oldvartype := vartype.ItemIndex;

  for i := 0 to panel5.ControlCount - 1 do
  begin
    panel5.Controls[i].Refresh;
    panel5.Controls[i].Repaint;
    panel5.Controls[i].Invalidate;
  end;


  if decbitvis then
    cbHexadecimal.Visible := False;

  scanvalue.Text := convertvalue(_oldvartype, _newvartype, oldvalue,
    washex, cbhexadecimal.Checked);


  panel5.OnResize(panel5); //lazarus, force the scantext left


  if ScanType.itemindex=-1 then
    ScanType.itemindex:=0; //just in case something has set it to -1

  if pnlScanValueOptions.visible then
  begin
    if foundlist3.width>pnlScanValueOptions.left then
      foundlist3.width:=foundlist3.width-(foundlist3.width-pnlScanValueOptions.left)-2;
  end;


end;

procedure TMainForm.LogoClick(Sender: TObject);
var s: string;
begin
  s:=format('http://www.cheatengine.org/?referredby=CE%.2f',[ceversion]);
  if messagedlg(rsDoYouWantToGoToTheCheatEngineWebsite, mtConfirmation,
    [mbYes, mbNo], 0) = mrYes then
    ShellExecute(0, PChar('open'), PChar(s),
      PChar(''), PChar(''), SW_MAXIMIZE);

end;

procedure TMainForm.VarTypeDropDown(Sender: TObject);
begin
  vartype.DropDownCount := vartype.items.Count;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose := mustclose or CheckIfSaved;
end;



procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  if messagedlg(strdeleteall, mtConfirmation, [mbNo, mbYes], 0) = mrYes then
    addresslist.Clear;
end;




procedure TMainForm.AddresslistDropByListview(Sender: TObject;
  node: TTreenode; attachmode: TNodeAttachMode);
var
  i: integer;
begin

  for i := 0 to foundlist3.Items.Count - 1 do
    if foundlist3.Items[i].Selected then
    begin
      try
        AddToRecord(i, node, attachmode);
      except
      end;
    end;

end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
  AddresslistDropByListview(addresslist, nil, naAdd);
end;



procedure TMainForm.Selectallitems1Click(Sender: TObject);
var
  i: integer;
begin
  foundlist3.BeginUpdate;
  try

    for i := 0 to foundlist3.Items.Count - 1 do
    begin
      //foundlist3.items[i].Selected := True;
      foundlist3.Items[i].Selected := True;
    end;
  finally
    foundlist3.EndUpdate;
  end;

end;



procedure TMainForm.Freezealladdresses2Click(Sender: TObject);
begin
  if addresslist.selectedRecord <> nil then
  begin
    if addresslist.selectedRecord.active then
      addresslist.DeactivateSelected
    else
      addresslist.ActivateSelected;
  end;
end;




procedure TMainForm.PopupMenu2Popup(Sender: TObject);

var
  i: integer;

  //6.0
  selectionCount: integer;
  selectedrecord: TMemoryRecord;

begin
  sethotkey1.Caption := rsSetChangeHotkeys;

  selectedrecord := addresslist.selectedRecord;
  selectionCount := 0;
  for i := 0 to addresslist.Count - 1 do
    if addresslist.MemRecItems[i].isSelected then
      Inc(selectioncount);


  miZeroTerminate.Visible := (selectedrecord <> nil) and (selectedrecord.VarType = vtString);
  miZeroTerminate.Checked := (miZeroTerminate.Visible) and
    (selectedrecord.Extra.stringData.ZeroTerminate);

  DeleteThisRecord1.Visible := (addresslist.selectedRecord <> nil);
  Change1.Visible := (addresslist.selectedrecord <> nil) and
    (not (addresslist.selectedRecord.vartype = vtAutoAssembler));
  address1.visible := (addresslist.selectedrecord <> nil) and (not addresslist.selectedRecord.isGroupHeader);
  Type1.visible := (addresslist.selectedrecord <> nil) and (not addresslist.selectedRecord.isGroupHeader);
  Value1.visible := (addresslist.selectedrecord <> nil);
  Smarteditaddresses1.visible := (addresslist.selectedrecord <> nil) and (not addresslist.selectedRecord.isGroupHeader);

  BrowseThisMemoryRegion1.Visible :=(addresslist.selectedRecord <> nil) and (not addresslist.selectedRecord.isGroupHeader) and (not (addresslist.selectedRecord.vartype = vtAutoAssembler));
  miDisassemble.Visible:=Browsethismemoryregion1.Visible;

  ShowAsHexadecimal1.Visible :=
    (addresslist.selectedRecord <> nil) and (addresslist.selectedRecord.VarType in
    [vtByte, vtWord, vtDword, vtQword, vtSingle, vtDouble, vtCustom, vtByteArray]) and
    (not addresslist.selectedRecord.isGroupHeader);


  miShowAsSigned.visible:=(addresslist.selectedRecord <> nil) and (not addresslist.selectedRecord.showAsHex) and (addresslist.selectedRecord.VarType<>vtAutoAssembler) and (not addresslist.selectedRecord.isGroupHeader);
  miShowAsSigned.Checked:=(addresslist.selectedRecord <> nil) and (addresslist.selectedrecord.showAsSigned);

  if (addresslist.selectedRecord <> nil) and (addresslist.selectedrecord.VarType =
    vtBinary) then
  begin
    if addresslist.selectedRecord.Extra.bitData.showasbinary then
      miShowAsBinary.Caption := rsShowAsDecimal
    else
      miShowAsBinary.Caption := rsShowAsBinary;

    miShowAsBinary.Visible := True;
  end
  else
    miShowAsBinary.Visible := False;


  if (addresslist.selectedRecord <> nil) then
  begin
    if not addresslist.selectedRecord.showAsHex then
      ShowAsHexadecimal1.Caption := rsShowAsHexadecimal
    else
      ShowAsHexadecimal1.Caption := rsShowAsDecimal;
  end;



  SetHotkey1.Visible := (addresslist.selectedRecord <> nil);
  if SetHotkey1.visible and addresslist.selectedRecord.hasHotkeys then
    SetHotkey1.caption:=rsSetChangeHotkeys
  else
    SetHotkey1.caption:=rsSetHotkeys;


  //6.1: Groupheaders can also have hotkeys (for toggle hotkeys)

  Freezealladdresses2.Visible := (addresslist.selectedRecord <> nil);

  Changescript1.Visible := (addresslist.selectedRecord <> nil) and
    (addresslist.selectedrecord.VarType = vtAutoAssembler);

  miAsyncScript.visible:=Changescript1.Visible;
  if miAsyncScript.visible then
    miAsyncScript.Checked:=addresslist.selectedrecord.Async;

  n5.Visible := (addresslist.selectedRecord <> nil);

  Pointerscanforthisaddress1.Visible :=
    (addresslist.selectedRecord <> nil) and (not addresslist.selectedRecord.isGroupHeader) and
    (not (addresslist.selectedRecord.vartype = vtAutoAssembler));

  miGeneratePointermap.Visible:=processid<>0;

  Findoutwhataccessesthisaddress1.Visible :=
    (addresslist.selectedRecord <> nil) and (not addresslist.selectedRecord.isGroupHeader) and
    (not (addresslist.selectedRecord.vartype = vtAutoAssembler));
  Setbreakpoint1.Visible := (addresslist.selectedRecord <> nil) and
    (not addresslist.selectedRecord.isGroupHeader) and
    (not (addresslist.selectedRecord.vartype = vtAutoAssembler));

  sep1.Visible := (addresslist.selectedRecord <> nil) and
    (not addresslist.selectedRecord.isGroupHeader) and
    (not (addresslist.selectedRecord.vartype = vtAutoAssembler));
  Calculatenewvaluepart21.Visible := (addresslist.Count > 0);
  Forcerechecksymbols1.Visible := addresslist.Count > 0;

  //one extra check for recalculate (don't show it when an aa address is selected)
  if (addresslist.selectedRecord <> nil) and
    (addresslist.selectedRecord.vartype = vtAutoAssembler) then
    Calculatenewvaluepart21.Visible := False;

  n4.Visible := (addresslist.Count > 0) or (miGeneratePointermap.visible);

  n1.Visible := True;
  CreateGroup.Visible := True;

  if (selectedrecord <> nil) and selectedrecord.treenode.HasChildren then
  begin
    miGroupconfig.Visible := True;
    miHideChildren.Checked := moHideChildren in selectedrecord.options;
    miBindActivation.Checked := moActivateChildrenAsWell in selectedrecord.options;
    miBindDeactivation.checked := moDeactivateChildrenAsWell in selectedrecord.options;
    miRecursiveSetValue.Checked := moRecursiveSetValue in selectedrecord.options;
    miAllowCollapse.checked := moAllowManualCollapseAndExpand in selectedrecord.options;
    miManualExpandCollapse.checked := moManualExpandCollapse in selectedrecord.options;
  end
  else
    miGroupconfig.Visible := False;

  miChangeColor.Visible := addresslist.selcount > 0;

  miUndoValue.Visible := (addresslist.selectedRecord <> nil) and
    (addresslist.selectedRecord.canUndo);

  miSetDropdownOptions.visible:=addresslist.selcount > 0;

  miDBVMFindWhatWritesOrAccesses.visible:=miChangeColor.Visible and isIntel and isDBVMCapable; //02/24/2019: Most cpu's support EPT now
  sep2.Visible:=miDBVMFindWhatWritesOrAccesses.Visible;

  miDBVMFindWhatWritesOrAccesses.enabled:=DBKLoaded;


  if (selectedrecord<>nil) and (selectedrecord.VarType=vtAutoAssembler) then
  begin
    miAutoAssembleErrorMessage.visible:=selectedrecord.LastAAExecutionFailed;
    if selectedrecord.LastAAExecutionFailed then
      miAutoAssembleErrorMessage.Caption:='<<'+selectedrecord.LastAAExecutionFailedReason+'>>';
  end;
end;

procedure TMainForm.foundlistpopupPopup(Sender: TObject);
var bytesize: integer;
  i, last: integer;
  mi: TMenuItem;
begin

  Browsethismemoryregioninthedisassembler1.Enabled := Foundlist3.SelCount >= 1;

  if foundlist3.Items.Count = 0 then
  begin
    Removeselectedaddresses1.Enabled := False;
    Browsethismemoryarrea1.Enabled := False;
    Selectallitems1.Enabled := False;
  end
  else
  begin
    Removeselectedaddresses1.Enabled := True;
    Browsethismemoryarrea1.Enabled := True;

    Selectallitems1.Enabled := foundlist3.Items.Count < 5000;
  end;

  if Foundlist3.SelCount > 1 then
    Removeselectedaddresses1.Caption := rsRemoveSelectedAddresses
  else
    Removeselectedaddresses1.Caption := rsRemoveSelectedAddress;

  if Foundlist3.selcount = 0 then
  begin
    Removeselectedaddresses1.Enabled := False;
    Browsethismemoryarrea1.Enabled := False;
  end
  else
  begin
    Removeselectedaddresses1.Enabled := True;
    Browsethismemoryarrea1.Enabled := True;
  end;

  if Removeselectedaddresses1.enabled then
    Removeselectedaddresses1.enabled := not (GetVarType in [vtBinary, vtByteArray, vtAll]);

  miChangeValue.enabled:=Browsethismemoryarrea1.enabled;
  miChangeValueBack.enabled:=Browsethismemoryarrea1.enabled;
  miAddAddress.enabled:=Browsethismemoryarrea1.enabled;

  //updatwe the display override
  if memscan<>nil then
    bytesize:=memscan.Getbinarysize div 8
  else
    bytesize:=1; //should never happen

  MenuItem19.visible:=(foundlist3.Items.Count>0) and (memscan<>nil);

  miDisplayDefault.visible:=(foundlist3.Items.Count>0) and (memscan<>nil);

  miDisplayByte.visible:=(foundlist3.Items.Count>0) and (memscan<>nil) and (bytesize>=1);
  miDisplay2Byte.visible:=(foundlist3.Items.Count>0) and (memscan<>nil) and (bytesize>=2);
  miDisplay4Byte.visible:=(foundlist3.Items.Count>0) and (memscan<>nil) and (bytesize>=4);
  miDisplay8Byte.visible:=(foundlist3.Items.Count>0) and (memscan<>nil) and (bytesize>=8);
  miDisplayFloat.visible:=(foundlist3.Items.Count>0) and (memscan<>nil) and (bytesize>=4);
  miDisplayDouble.visible:=(foundlist3.Items.Count>0) and (memscan<>nil) and (bytesize>=8);
  miDisplayHex.visible:=(foundlist3.Items.Count>0) and (memscan<>nil) and (bytesize>=1);

//  miDisplayHex.caption:
  if foundlist<>nil then
  begin
    if foundlist.isHexadecimal then
      miDisplayHex.caption:=rsDecimal
    else
      miDisplayHex.caption:=rsHexadecimal
  end;



  if (foundlist3.Items.Count>0) and (memscan<>nil) then
  begin
    //populate the list with custom types
    last:=foundlistpopup.Items.IndexOf(miDisplayDouble)+1;
    //first delete the current list (new one could have been added)

    while foundlistpopup.Items.Count>last do
      foundlistpopup.Items.Delete(last);

    for i:=0 to customTypes.Count-1 do
    begin
      if TCustomType(customTypes[i]).bytesize<=bytesize then
      begin
        mi:=TMenuItem.Create(foundlistpopup);
        mi.Caption:=TCustomType(customTypes[i]).name;
        mi.RadioItem:=miDisplayDouble.RadioItem;
        mi.AutoCheck:=miDisplayDouble.AutoCheck;
        mi.GroupIndex:=miDisplayDouble.GroupIndex;
        mi.OnClick:=miChangeDisplayTypeClick;
        mi.tag:=1000+i;
        foundlistpopup.Items.Add(mi);

        if foundlistDisplayOverride=mi.tag then
          mi.Checked:=true;
      end;
    end;


    menuitem14.visible:=(memscan.lastScanWasRegionScan=false) and (memscan.VarType in [vtAll, vtByte, vtWord, vtDword, vtQword, vtSingle, vtDouble]);      ;
    miForgotScan.visible:=(memscan.lastScanWasRegionScan=false) and (memscan.VarType in [vtAll, vtByte, vtWord, vtDword, vtQword, vtSingle, vtDouble]);      ;
  end
  else
  begin
    menuitem14.visible:=false;
    miForgotScan.visible:=false;
  end;

  miFlFindWhatAccesses.enabled:=Browsethismemoryarrea1.enabled;
  miFlFindWhatWrites.enabled:=Browsethismemoryarrea1.enabled;

end;

procedure TMainForm.Removeselectedaddresses1Click(Sender: TObject);
var
  e, i, j: integer;
  bit: byte;
  selected: array of integer;
begin

  if SaveFirstScanThread <> nil then
  begin
    SaveFirstScanThread.WaitFor; //wait till it's done
    FreeAndNil(SaveFirstScanThread);
  end;

  if PreviousResults<>nil then
    PreviousResults.deinitialize;

  if foundlist3.selcount = 1 then //use itemindex (faster)
  begin
    foundlist.deleteaddress(foundlist3.ItemIndex);
  end
  else if foundlist3.selcount > 1 then
  begin
    if foundlist3.items.Count > 100000 then
      if messagedlg(rsThisListIsHuge, mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
        exit;

    screen.Cursor := crhourglass;

    //MainForm.Caption := CEWait;
    //Mainform.Refresh;

    foundlist3.Items.BeginUpdate;
    try
      j := 0;
      setlength(selected, foundlist3.selcount);
      for i := 0 to foundlist3.items.Count - 1 do
      begin
        if foundlist3.items[i].Selected then
        begin
          selected[j] := i;
          Inc(j);
        end;
      end;

      for i := length(selected) - 1 downto 0 do
        foundlist.deleteaddress(selected[i]);

    finally
      //Mainform.Caption := CENorm;
      screen.Cursor := crDefault;
      foundlist3.Items.EndUpdate;
    end;
  end;

  foundcount:=foundlist.Reinitialize;

  if PreviousResults<>nil then
    PreviousResults.reinitialize;



end;



procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
  reg: Tregistry;
  crashcounter: integer;

  h: thandle;


begin
  i:=0;
  while i<screen.CustomFormCount do
  begin
    if (screen.CustomForms[i] is TCEForm) then
    begin
      screen.CustomForms[i].Free;
    end
    else
      inc(i);
  end;

  if adwindow <> nil then
    FreeAndNil(adwindow);

  //cleanup the user forms
  if formdesigner <> nil then
    formdesigner.Close;

  //undo unrandomize
  if unrandomize <> nil then
    FreeAndNil(unrandomize);

  cbSpeedhack.Checked := False;

  if flashprocessbutton <> nil then
  begin
    flashprocessbutton.Terminate;
    flashprocessbutton.WaitFor;
    FreeAndNil(FlashProcessButton);
  end;

  try
    if @DebugActiveProcessStop <> @DebugActiveProcessStopProstitute then
    begin
      //detach the debugger
      //hide;
      crashcounter := 0;
      if advancedoptions <> nil then
      begin
        if advancedoptions.Pausebutton.Down then
        begin
          advancedoptions.Pausebutton.Down := False;
          advancedoptions.Pausebutton.Click;
        end;
      end;


      if debuggerthread <> nil then
      begin
        debuggerthread.Terminate;
        debuggerthread.WaitFor;
        debuggerthread.Free;
        debuggerthread := nil;
      end;
    end;
  except

  end;

  if frmProcessWatcher <> nil then
    freeandnil(frmProcessWatcher);

  try
    if tempbitmap<>nil then
      freeandnil(tempbitmap);

    shutdown;

   // unregisterhotkey(handle, 0);
  except

  end;

  if advancedoptions <> nil then
  begin
    if advancedoptions.Pausebutton.Down then
    begin
      with advancedoptions do
      begin
        pausebutton.down := not pausebutton.down;
        pausebutton.Click;
      end;
    end;
  end;

  if length(windowlist) > 0 then
  begin
    toggleWindow;
    setforegroundwindow(lastforeground);
    setactivewindow(lastactive);
  end;

  if autoattachlist<>nil then
    FreeAndNil(autoattachlist);


  if speedhack <> nil then
    FreeAndNil(speedhack);

  if pluginhandler <> nil then
  begin
    pluginhandler.free;
    pluginhandler:=nil;
  end;



end;


procedure TMainForm.CommentButtonClick(Sender: TObject);
begin
  comments.Show;
end;

procedure TMainForm.CommentButtonMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
begin

end;

procedure TMainForm.CopySelectedRecords;
begin
  clipboard.astext := addresslist.GetTableXMLAsText(True);
end;

procedure TMainForm.paste(simplecopypaste: boolean);
{
this routine will paste a entry from the cplipboard into the addresslist of CE
If simplecopypaste is false frmPasteTableentry is shown to let the user change
some stuff before adding the new entry

returns the entry number of the new addresses (first one)
}
var
  s: string;
begin
  s := clipboard.AsText;
  addresslist.AddTableXMLAsText(s, simplecopypaste);
end;

procedure TMainForm.Copy1Click(Sender: TObject);
begin

  copyselectedrecords;
end;

procedure TMainForm.Cut1Click(Sender: TObject);
begin
  copyselectedrecords;
  addresslist.DeleteSelected(False);
end;

procedure TMainForm.Paste1Click(Sender: TObject);
begin
  Paste(formsettings.cbsimplecopypaste.Checked);
end;

procedure TMainForm.miDBVMFindWhatWritesOrAccessesClick(Sender: TObject);

var
  address: ptrUint;
  res: word;
  id: integer;

  fcd: TFoundCodeDialog;
  unlockaddress: qword;
  canuseept: boolean;

begin
  LoadDBK32;

  canuseept:=hasEPTSupport;
  if (isintel=false) or (isDBVMCapable=false) then
  begin
    messagedlg('This function requires an Intel CPU with virtualization support. If your system has that then make sure that you''re currently not running inside a virtual machine. (Windows has some security features that can run programs inside a VM)', mtError,[mbok],0);
    exit;
  end;

  if canuseept=false then
  begin
    messagedlg('This function requires that your CPU supports ''Extended Page Table (EPT)'' which your CPU lacks',mtError,[mbok],0);
    exit;
  end;

  if loaddbvmifneeded('DBVM find routines needs DBVM for EPT page hooking. Loading DBVM can potentially cause a system freeze. Are you sure?') then
  begin

    if addresslist.selectedRecord <> nil then
    begin
      if not loaddbvmifneeded then exit;

      address := addresslist.selectedRecord.GetRealAddress;

      if addresslist.selectedRecord.IsPointer then
      begin
        with TformPointerOrPointee.Create(self) do
        begin
          btnFindWhatWritesPointer.Caption := rsFindOutWhatAccessesThisPointer;
          btnFindWhatWritesPointee.Caption := rsFindWhatAccessesTheAddressPointedAtByThisPointer;

          res := showmodal;
          if res = mrNo then //find what writes to the address pointer at by this pointer
            address := addresslist.selectedRecord.GetRealAddress
          else
          if res = mrYes then
            address := symhandler.getAddressFromName(
              addresslist.selectedRecord.interpretableaddress)
          else
            exit;
        end;
      end;

      //spawn a DBVM watch config screen where the user can select options like lock memory
      if frmDBVMWatchConfig=nil then
        frmDBVMWatchConfig:=TfrmDBVMWatchConfig.create(self);

      frmDBVMWatchConfig.address:=address;
      if frmDBVMWatchConfig.showmodal=mrok then
      begin
        if frmDBVMWatchConfig.LockPage then
          unlockaddress:=LockMemory(processid, address and QWORD($fffffffffffff000),4096)
        else
          unlockaddress:=0;

        case frmDBVMWatchConfig.watchtype of
          0: id:=dbvm_watch_writes(frmDBVMWatchConfig.PhysicalAddress, addresslist.selectedRecord.bytesize, frmDBVMWatchConfig.Options, frmDBVMWatchConfig.MaxEntries);
          1: id:=dbvm_watch_reads(frmDBVMWatchConfig.PhysicalAddress, addresslist.selectedRecord.bytesize, frmDBVMWatchConfig.Options, frmDBVMWatchConfig.MaxEntries);
          2: id:=dbvm_watch_executes(frmDBVMWatchConfig.PhysicalAddress, addresslist.selectedRecord.bytesize, frmDBVMWatchConfig.Options, frmDBVMWatchConfig.MaxEntries);
          else
            id:=-1;
        end;

        if (id<>-1) then
        begin
          //spawn a foundcodedialog
          fcd:=TFoundCodeDialog.Create(self);
          fcd.multipleRip:=frmDBVMWatchConfig.cbMultipleRIP.Checked;
          fcd.dbvmwatchid:=id;
          fcd.dbvmwatch_unlock:=unlockaddress;
          if frmDBVMWatchConfig.watchtype=0 then
            fcd.caption:=Format(rsTheFollowingOpcodesAccessed, [inttohex(address, 8)])
          else
            fcd.caption:=Format(rsTheFollowingOpcodesWriteTo, [inttohex(address, 8)]);


          fcd.show;
        end
        else
          MessageDlg('dbvm_watch failed', mtError, [mbok],0);

      end;
      freeandnil(frmDBVMWatchConfig);


    end;
  end;


end;

procedure TMainForm.Findoutwhataccessesthisaddress1Click(Sender: TObject);
var
  address: ptrUint;
  res: word;
begin
  if addresslist.selectedRecord <> nil then
  begin
    address := addresslist.selectedRecord.GetRealAddress;
    if (not startdebuggerifneeded) then
      exit;

    if addresslist.selectedRecord.IsPointer then
    begin
      with TformPointerOrPointee.Create(self) do
      begin
        btnFindWhatWritesPointer.Caption := rsFindOutWhatAccessesThisPointer;
        btnFindWhatWritesPointee.Caption := rsFindWhatAccessesTheAddressPointedAtByThisPointer;

        res := showmodal;
        if res = mrNo then //find what writes to the address pointer at by this pointer
          address := addresslist.selectedRecord.GetRealAddress
        else
        if res = mrYes then
          address := symhandler.getAddressFromName(
            addresslist.selectedRecord.interpretableaddress)
        else
          exit;
      end;
    end;

    DebuggerThread.FindWhatAccesses(address, addresslist.selectedRecord.bytesize); //byte

  end;
end;

procedure TMainForm.Setbreakpoint1Click(Sender: TObject);
var
  address: ptrUint;
  res: word;
begin
  OutputDebugString('Setbreakpoint1Click');

  if addresslist.selectedRecord <> nil then
  begin
    address := addresslist.selectedRecord.GetRealAddress;

    if (not startdebuggerifneeded) then
      exit;

    if addresslist.selectedRecord.IsPointer then
    begin
      with TformPointerOrPointee.Create(self) do
      begin
        btnFindWhatWritesPointer.Caption := rsFindOutWhatWritesThisPointer;
        btnFindWhatWritesPointee.Caption := rsFindWhatWritesTheAddressPointedAtByThisPointer;

        res := showmodal;
        if res = mrNo then //find what writes to the address pointer at by this pointer
          address := addresslist.selectedRecord.GetRealAddress
        else
        if res = mrYes then
          address := symhandler.getAddressFromName(
            addresslist.selectedRecord.interpretableaddress)
        else
          exit;
      end;
    end;

    DebuggerThread.FindWhatWrites(address, addresslist.selectedRecord.bytesize);

    //debug
   //debuggerthread.SetOnWriteBreakpoint(address, addresslist.selectedRecord.bytesize, bpmException);

  end;
end;

procedure TMainForm.TopDisablerTimer(Sender: TObject);
begin
  setwindowpos(mainform.Handle, HWND_NOTOPMOST, mainform.left, mainform.top,
    mainform.Width, mainform.Height, SWP_SHOWWINDOW);
  TopDisabler.Enabled := False;
end;

procedure TMainForm.advancedbuttonClick(Sender: TObject);
begin
  advancedoptions.Show;
end;

procedure TMainForm.cbHexadecimalClick(Sender: TObject);
var
  x: qword;
  i: integer;
begin

  if dontconvert then
    exit;

  if cbHexadecimal.Checked then
  begin
    //convert what is in scanvalue to hexadecimal notation
    val(scanvalue.Text, x, i);
    case GetVarType of
      vtByte: scanvalue.Text := IntToHex(byte(x), 2);
      vtWord: scanvalue.Text := inttohex(word(x), 4);
      vtDword: scanvalue.Text := inttohex(dword(x), 8);
      vtQword: scanvalue.Text := inttohex(qword(x), 16);
    end;

  end
  else
  begin
    //convert to decimal notation
    case GetVarType of
      vtByte, vtWord, vtDword, vtQWord:
      begin
        if length(scanvalue.Text) > 0 then
        begin
          if scanvalue.Text[1] = '-' then
            val('-$' + copy(scanvalue.Text, 2, length(scanvalue.Text)), x, i)
          else
            val('$' + scanvalue.Text, x, i);

          scanvalue.Text := IntToStr(x);
        end;
      end;
    end;
  end;
end;

procedure TMainForm.SetHotkey1Click(Sender: TObject);
begin
  {  HotKeyForm.recnr:=lastselected;}
  if addresslist.selectedRecord=nil then exit;
  if addresslist.selectedRecord.isBeingEdited then
    exit;

  with THotKeyForm.Create(self) do
  begin
    memrec := addresslist.selectedRecord;
    if memrec<>nil then
    begin
      memrec.beginEdit;
      Show;
    end;
  end;
end;


procedure TMainForm.UndoScanClick(Sender: TObject);
var
  i, j: integer;
  error: integer;
  a, b: string;

begin

  if messagedlg(strConfirmUndo, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if PreviousResults<>nil then
      freeandnil(PreviousResults);


    foundlist.Deinitialize;
    memscan.undolastscan;
    foundcount := foundlist.Initialize(getvartype, memscan.CustomType);

    try
      previousresults:=TSavedScanHandler.create(memscan.GetScanFolder, currentlySelectedSavedResultname);
      previousresults.AllowNotFound:=true;
      PreviousResults.AllowRandomAccess:=true;
    except
    end;

    undoscan.Enabled := False;
  end;
end;

procedure TMainForm.adjustbringtofronttext;
var
  hotkey: string;
  reg: TRegistry;

begin
  if formsettings.cbHideAllWindows.Checked then
  begin
    if allwindowsareback then
    begin
      if onlyfront then
        fronttext := strHideForeground
      else
        fronttext := strHideAll;
    end
    else
    begin
      if onlyfront then
        fronttext := strUnhideForeground
      else
        fronttext := strUnhideAll;
    end;

  end
  else
    fronttext := rsBringsCheatEngineToFront;


  hotkey:=cereg.readString('BringToFrontHotkey');
end;




procedure TMainForm.FormShow(Sender: TObject);


var
  reg: tregistry;
  modifier: dword;
  key: dword;
  hotkey: string;
  year, month, day: word;
  temp: string;

  i,j: integer;
  outputfile: textfile;
  go: boolean;
  loadt: boolean;

  firsttime: boolean;
  x: array of integer;

  t: tcomponent;


  ReferenceControl: TControl;
  ReferenceSide : TAnchorSideReference;
  Position: integer;

  c: TControl;

  logopic: TPicture;
  rs: TResourceStream;
  cleanrun: boolean;

  cbi: TComboboxInfo;
  extrasize: integer;
  s: string;
begin
  if onetimeonly then
    exit;

  fontmultiplication:=ProcessLabel.Height/15; //normal dpi/font settings have this at 15.

  screen.HintFont:=font;


  onetimeonly := True;
  Set8087CW($133f);
  SetSSECSR($1f80);

  loadt := False;
  editsh2.Text := format('%.1f', [1.0]);


  reg := Tregistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;

    if not Reg.OpenKey('\Software\Cheat Engine', False) then //can't be opened. Clean install
    begin
      if Reg.OpenKey('\Software\Cheat Engine', True) then
      begin
        //write some default data into the registry
        reg.WriteBool('Undo', True);
        reg.writeBool('Advanced', True);

        reg.WriteInteger('ScanThreadpriority',
          formsettings.combothreadpriority.ItemIndex);
      end;
    end;
  except

  end;

  if reg.ValueExists('First Time User') then
    firsttime := reg.ReadBool('First Time User')
  else
    firsttime := True;

  if firsttime then
  begin
    reg.WriteBool('First Time User', False);

    if formsettings.lbLanguages.Count>1 then
    begin
      i:=ShowSelectionList(self, rsLanguage, rsChooseLanguage, formSettings.lbLanguages.Items, s);
      if i<>-1 then
      begin
        formSettings.lbLanguages.ItemIndex:=i;
        formsettings.btnSelectLanguage.Click;
      end;
    end;

    if messagedlg(rsTryTutorial, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      miTutorial.Click;
  end;

  if reg.ValueExists('Show previous value column') then
  begin
    miShowPreviousValue.checked:=reg.ReadBool('Show previous value column');
    miShowPreviousValueClick(miShowPreviousValue);
  end;




  //  animatewindow(mainform.Handle,10000,AW_CENTER);
  //mainform.repaint;
  fronttext := rsBringsCheatEngineToFront;

  if dontrunshow then
    exit;

  panel7.DoubleBuffered := True;
  flashprocessbutton := tflash.Create(False);



  dontrunshow := True;
  decodedate(now, year, month, day);
  if (month = 7) and (day = 1) then
    ShowMessage(strhappybirthday);
  if (month = 1) and (day = 1) then
  begin
    if reg.ValueExists('ShownHappyNewYear'+inttostr(year))=false then
    begin
      ShowMessage(strnewyear);
      reg.WriteBool('ShownHappyNewYear'+inttostr(year), true);
    end;
  end;
  if (month = 1) and (day = 1) and (year >= 2020) then
    ShowMessage(strFuture);

  if (month = 4) and (day = 1) then
    aprilfools := True;

  if aprilfools = True then
    Messagedlg(
      rsLicenseExpired, mtWarning, [mbOK], 0);

  //Load the table if one was suplied
  overridedebug := False;


  if (GetSystemType < 4) {or (is64bitos)} then  //not nt or later
  begin
    with formsettings do
    begin
      cbKernelQueryMemoryRegion.Enabled := False;
      cbKernelReadWriteProcessMemory.Enabled := False;
      cbKernelOpenProcess.Enabled := False;
      cbProcessWatcher.Enabled := False;
      cbKDebug.Enabled := False;
      cbGlobalDebug.Enabled := False;

      TauntOldOsUser.Visible := True;
    end;
  end;



  vartypechange(vartype);
  adjustbringtofronttext;


  if aprilfools then
    Caption := cenorm + ' ' + rsEXPIRED + '!';

  if autoattachtimer.Enabled then
    autoattachcheck
  else
    AutoAttachThread:=TAutoAttachThread.Create(false);




  //SMenu:=GetSystemMenu(handle,false);
  cleanrun:=autosize;
  autosize:=false;


  memscan := tmemscan.Create(ProgressBar);
  memscan.GuiScanner:=true;
  memscan.OnGuiUpdate:=MemscanGuiUpdate;
  memscan.OnInitialScanDone:=scandone;

  foundlist := tfoundlist.Create(foundlist3, memscan);


  logo.Width:=settingsbutton.width;

  if logo.Width>=90 then
  begin
    rs := TResourceStream.Create(HInstance, 'IMAGES_CELOGO', RT_RCDATA);
    logopic:=TPicture.Create;
    logopic.LoadFromStreamWithFileExt(rs,'.PNG');
    logo.Picture:=logopic;
    logo.Stretch:=true;


    logopic.free;
    freeandnil(rs);
  end;

  if settingsbutton.Width>logo.Picture.Width then
    logo.Width:=settingsbutton.width;

  if logo.Width>=80 then
  begin
    rs := TResourceStream.Create(HInstance, 'IMAGES_CELOGO', RT_RCDATA);
    logopic:=TPicture.Create;
    logopic.LoadFromStreamWithFileExt(rs,'.PNG');
    logo.Picture:=logopic;
    logo.Stretch:=true;


    logopic.free;
    freeandnil(rs);
  end;

  logo.Height:=trunc((logo.Width / logo.picture.Width)*logo.picture.Height);

  sbOpenProcess.BorderSpacing.Around:=ScaleX(sbOpenProcess.BorderSpacing.Around, 96);
  loadbutton.BorderSpacing.Top:=sbOpenProcess.BorderSpacing.Around;


  //because the images have no empty border autosize is out of the question as that makes them hug the border. So, scale them manually
  sbOpenProcess.Width:=scalex(sbOpenProcess.Width, 96);
  sbOpenProcess.Height:=scaley(sbOpenProcess.Height, 96);

  LoadButton.Width:=scalex(LoadButton.Width, 96);
  LoadButton.Height:=scaley(LoadButton.Height, 96);

  SaveButton.Width:=scalex(SaveButton.Width, 96);
  SaveButton.Height:=scaley(SaveButton.Height, 96);

  SpeedButton2.Width:=scalex(SpeedButton2.Width, 96);
  SpeedButton2.Height:=scaley(SpeedButton2.Height, 96);

  SpeedButton3.Width:=scalex(SpeedButton3.Width, 96);
  SpeedButton3.Height:=scaley(SpeedButton3.Height, 96);


  if panel7.Height>ProgressBar.Top+ProgressBar.Height then
    label6.AnchorSideTop.Control:=panel7
  else
    label6.AnchorSideTop.Control:=ProgressBar;


  panel5resize(panel5);

  if WindowsVersion>=wvVista then
  begin
    i:=sendmessage(scanvalue.Handle, EM_GETMARGINS, 0,0);
    i:=(i shr 16)+(i and $ffff);
  end
  else
    i:=8;

  editSH2.Constraints.MinWidth:=canvas.TextWidth('500.0 ')+i;


  edtAlignment.Constraints.MinWidth:=canvas.TextWidth('XXXX');
  edtAlignment.Constraints.MaxWidth:=canvas.TextWidth('XXXXX');

  panel6.clientheight:=cbPauseWhileScanning.top+cbPauseWhileScanning.height+2;
  gbScanOptions.ClientHeight:=panel6.top+panel6.height+2;

  if reg<>nil then
    freeandnil(reg);

  btnNewScan.autosize:=true;
  btnNextScan.AutoSize:=true;
  btnNewScan.autosize:=false;
  btnNextScan.AutoSize:=false;

  i:=max(btnNewScan.Width, btnNextScan.Width);
  btnNewScan.width:=i;
  btnNextScan.width:=i;

  btnAddAddressManually.autosize:=true;
  btnAddAddressManually.autosize:=false;
  btnMemoryView.autosize:=true;
  btnMemoryView.autosize:=false;
  i:=max(btnAddAddressManually.Width, btnMemoryView.Width);
  btnAddAddressManually.width:=i;
  btnMemoryView.width:=i;

  i:=canvas.TextHeight('ygGxX');
  btnAddAddressManually.ClientHeight:=i+4;
  btnMemoryView.ClientHeight:=i+4;


  cbi.cbSize:=sizeof(cbi);
  if GetComboBoxInfo(vartype.handle, @cbi) then
    extrasize:=cbi.rcButton.Right-cbi.rcButton.Left+cbi.rcItem.Left
  else
    extrasize:=16;

  i:=Canvas.TextWidth(rsMUGenerateGroupscanCommand)+extrasize;
  i:=max(i, Canvas.TextWidth(strExactValue)+extrasize);
  i:=max(i, Canvas.TextWidth(strBiggerThan)+extrasize);
  i:=max(i, Canvas.TextWidth(strsmallerThan)+extrasize);
  i:=max(i, Canvas.TextWidth(strValueBetween)+extrasize);
  i:=max(i, Canvas.TextWidth(strUnknownInitialValue)+extrasize);
  i:=max(i, Canvas.TextWidth(strIncreasedValue)+extrasize);
  i:=max(i, Canvas.TextWidth(strIncreasedValueBy)+extrasize);
  i:=max(i, Canvas.TextWidth(strDecreasedValue)+extrasize);
  i:=max(i, Canvas.TextWidth(strDecreasedValueBy)+extrasize);
  i:=max(i, Canvas.TextWidth(strChangedValue)+extrasize);
  i:=max(i, Canvas.TextWidth(strUnchangedValue)+extrasize);
  i:=max(i, Canvas.TextWidth(strCompareToLastScan)+extrasize);
  i:=max(i, Canvas.TextWidth(strCompareToFirstScan)+extrasize);
  i:=max(i, Canvas.TextWidth(strcompareToSavedScan)+extrasize);

  vartype.Constraints.MinWidth:=i;

  i:=foundlist3.width;
  if undoscan.left<btnNextScan.Left+btnNextScan.Width then
  begin
    j:=(btnNextScan.Left+btnNextScan.Width)-undoscan.left;
    i:=foundlist3.width-j;
  end;

  pnlFloat.Visible:=true;
  panel9.Constraints.MinWidth:=panel9.Width;
  pnlFloat.Visible:=false;



  pnlScanOptions.Constraints.MinHeight:=gbScanOptions.Top-panel9.top;
  panel10.Constraints.MinWidth:=max(panel14.Width, panel10.Width);

  pnlScanValueOptions.Constraints.MinHeight:=rbBit.Height+rbDec.height;
  pnlScanValueOptions.Constraints.MinWidth:=max(rbDec.width, rbBit.width);

  if i>pnlScanValueOptions.left then
    i:=pnlScanValueOptions.left-4;

  if i>lblValueType.left then
    i:=lblValueType.left-4;

  if i>gbScanOptions.left then
    i:=gbScanOptions.left-4;

  if i+speedbutton3.Width>gbScanOptions.left then
    dec(i, (i+speedbutton3.Width)-gbScanOptions.left)
  else
  begin
    gbScanOptions.AnchorSideLeft.Control:=speedbutton3;
    gbScanOptions.AnchorSideLeft.Side:=asrRight;
    gbScanOptions.Anchors:=gbScanOptions.Anchors+[akLeft];
  end;

  if i<0 then
  begin
    clientwidth:=clientwidth+(-i);
    foundlist3.width:=1;
  end
  else
    foundlist3.width:=i;



  if speedbutton2.top<btnMemoryView.Top then
    foundlist3.AnchorSideBottom.Control:=speedbutton2;


  lblcompareToSavedScan.left:=btnNewScan.left-(lblcompareToSavedScan.Width div 2)+((btnNextScan.left+btnNextScan.Width-btnNewScan.left) div 2);

  ProgressBar.height:=scaley(ProgressBar.height, 96);

  i:=((logopanel.Top+logopanel.height)-scanvalue.top)+2;
  if i>0 then
    scantext.BorderSpacing.Top:=scantext.BorderSpacing.Top+i;

  if pnlScanValueOptions.top+pnlScanValueOptions.Height>scanvalue.top+scanvalue.height then
    scantype.AnchorSideTop.Control:=pnlScanValueOptions
  else
  begin
    scantype.AnchorSideTop.Control:=scanvalue;
    scantype.BorderSpacing.Top:=2;
  end;

  panel9.borderspacing.Top:=(scantype.height div 2)-(cbNot.Height div 2);

  i:=GetFontData(font.Handle).Height;


  fromaddress.Font.Height:=i;
  toaddress.Font.Height:=i;
  Foundlist3.Font.Height:=i;


  panel5.Constraints.MinHeight := gbScanOptions.top + gbScanOptions.Height + max(speedbutton2.Height, btnAddAddressManually.height ) + 10;



  if cleanrun then //clean setup
  begin
    foundlist3.Column[0].AutoSize:=true;
    foundlist3.Column[1].AutoSize:=true;
    foundlist3.Column[2].AutoSize:=true;

    j:=max(foundlist3.canvas.textwidth('DDDDDDDDDDDDD'), foundlist3.Column[0].Width);

    foundlist3.Column[0].AutoSize:=false;
    foundlist3.Column[0].Width:=j;

    i:=j+foundlist3.Column[1].Width+foundlist3.Column[2].Width  ;


    foundlist3.Column[1].AutoSize:=false;
    foundlist3.Column[2].AutoSize:=false;

    if foundlist3.clientWidth<i then
      width:=width+(i-foundlist3.clientWidth);

    i:=panel5.Height+splitter1.height+addresslist.headers.Height+btnNewScan.Height*4;
    if clientheight<i then
      clientheight:=i;

    self.position:=poDesigned;
    self.position:=poScreenCenter;

    i:=addresslist.headers.Canvas.TextWidth(addresslist.headers.Sections[0].Text+' ');
    if i>addresslist.headers.Sections[0].Width then addresslist.headers.Sections[0].Width:=i;

    i:=max(addresslist.headers.Canvas.TextWidth(addresslist.headers.Sections[1].Text), addresslist.headers.Canvas.TextWidth(strNoDescription));
    if i>addresslist.headers.Sections[1].Width then addresslist.headers.Sections[1].Width:=i;

    i:=max(addresslist.headers.Canvas.TextWidth(addresslist.headers.Sections[2].Text), addresslist.headers.Canvas.TextWidth('P->DDDDDDDDDDDD'));
    if i>addresslist.headers.Sections[2].Width then addresslist.headers.Sections[2].Width:=i;

    i:=max(addresslist.headers.Canvas.TextWidth(addresslist.headers.Sections[3].Text), addresslist.headers.Canvas.TextWidth(rs_vtByteArray));
    if i>addresslist.headers.Sections[3].Width then addresslist.headers.Sections[3].Width:=i;


    //initial state: focus on the addresslist
    panel5.height:=gbScanOptions.top+gbScanOptions.Height;

  end;

  panel5.OnResize(panel5);

  btnSetSpeedhack2.AutoSize:=false;
  btnSetSpeedhack2.Height:=btnAddAddressManually.Height;

  scantype.Anchors:=[akRight];
  scantype.AnchorSideTop.Control:=nil;
  scantype.Anchors:=[akRight, akTop];

  if not memscan.canWriteResults then
    MessageDlg(Format(rsInvalidScanFolder, [memscan.GetScanFolder]), mtError, [mbOk], 0);

 // ImageList2.GetBitmap(0);

end;



procedure TMainForm.rbBitClick(Sender: TObject);
begin

  if not isbit then
  begin
    isbit := True;
    //convert the value to a binary value
    try
      if scanvalue.Text = '' then
        scanvalue.Text := '0'
      else
        scanvalue.Text := inttobin(StrToQWordEx(scanvalue.Text));
      if scanvalue.Text = '' then
        scanvalue.Text := '0';
    except

    end;
  end;

end;

procedure TMainForm.rbDecClick(Sender: TObject);
begin
  if isbit then
  begin
    isbit := False;
    //convert the binary text to a decimal representation
    scanvalue.Text := IntToStr(parsers.BinToInt(scanvalue.Text));
  end;
end;

procedure TMainForm.Cut2Click(Sender: TObject);
var e: TEdit;
begin
  e:=nil;
  if scanvalue.Focused then e:=scanvalue;
  if (scanvalue2<>nil) and scanvalue2.Focused then e:=scanvalue2;
  if e=nil then exit;

  if e.SelLength > 0 then
    e.CutToClipboard;
end;

procedure TMainForm.Copy2Click(Sender: TObject);
var e: tedit;
begin
  e:=nil;
  if scanvalue.Focused then e:=scanvalue;
  if (scanvalue2<>nil) and scanvalue2.Focused then e:=scanvalue2;

  if e=nil then exit;

  if e.SelLength > 0 then
    e.CopyToClipboard;
end;

procedure TMainForm.Paste2Click(Sender: TObject);
var
  cb: TClipboard;
  Text: string;
  i: integer;
  allow: boolean;
  e: tedit;
begin
  cb := tclipboard.Create;
  try
    if cb.HasFormat(CF_TEXT) then
    begin
      e:=nil;
      if scanvalue.Focused then e:=scanvalue;
      if (scanvalue2<>nil) and scanvalue2.Focused then e:=scanvalue2;

      if e=nil then exit;

      e.PasteFromClipboard;
    end;
  finally
    cb.Free;
  end;
end;

procedure TMainForm.checkpaste;
var
  cb: TClipboard;
  Text: string;
  i: integer;
  allow: boolean;
begin
  cb := tclipboard.Create;
  Paste2.Enabled := cb.HasFormat(CF_TEXT);
  cb.Free;
end;

procedure TMainForm.ccpmenuPopup(Sender: TObject);
begin
  checkpaste;
end;

procedure TMainForm.Splitter1CanResize(Sender: TObject; var NewSize: integer;
  var Accept: boolean);
begin

end;

procedure TMainForm.Splitter1Moved(Sender: TObject);
begin
  panel5.Repaint;
end;

procedure TMainForm.SettingsClick(Sender: TObject);
var
  oldmodulelist: pointer;
  oldScanDone, oldInitialScanDone: TNotifyEvent;
begin

  suspendhotkeyhandler;

  oldmodulelist := modulelist;

  if formsettings.ShowModal <> mrOk then
  begin
    resumehotkeyhandler;
    LoadSettingsFromRegistry(true);
    exit;
  end;


  resumehotkeyhandler;


  if formsettings.cbKernelQueryMemoryRegion.Checked then
    UseDBKQueryMemoryRegion
  else
    DontUseDBKQueryMemoryRegion;
  if formsettings.cbKernelReadWriteProcessMemory.Checked then
    UseDBKReadWriteMemory
  else
    DontUseDBKReadWriteMemory;
  if formsettings.cbKernelOpenProcess.Checked then
    UseDBKOpenProcess
  else
    DontUseDBKOpenProcess;

  adjustbringtofronttext;

  if not btnNextScan.Enabled then
  begin
    //memscan can be reset
    if memscan <> nil then
    begin
      oldScanDone:=memscan.OnScanDone;
      oldInitialScanDone:=memscan.OnInitialScanDone;
      memscan.Free;
    end
    else
    begin
      oldScanDone:=nil;
      oldInitialScanDone:=scanDone;
    end;

    memscan := tmemscan.Create(ProgressBar);
    memscan.GuiScanner:=true;
    memscan.OnGuiUpdate:=memscanGuiUpdate;
    memscan.OnScanDone:=oldScanDone;
    memscan.OnInitialScanDone:=oldInitialScanDone;
  end;
end;

procedure TMainForm.cbCaseSensitiveClick(Sender: TObject);
begin
  cbHexadecimal.Checked := cbcasesensitive.Checked;
end;

procedure TMainForm.LogoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if button = mbright then
    miAbout.click;
end;


procedure TMainForm.OpenProcesslist1Click(Sender: TObject);
begin
  sbOpenProcess.Click;
end;

procedure TMainForm.CloseCheatEngine1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.Showashexadecimal1Click(Sender: TObject);
var
  i: integer;
  newstate: boolean;
begin
  if addresslist.selectedRecord <> nil then
  begin
    newstate := not addresslist.selectedRecord.showAsHex;

    for i := 0 to addresslist.Count - 1 do
      if addresslist[i].isSelected then
        addresslist[i].showAsHex := newstate;
  end;
end;

procedure TMainForm.OpenMemorybrowser1Click(Sender: TObject);
begin
  btnMemoryView.click;
end;

procedure TMainForm.cbSaferPhysicalMemoryChange(sender: tobject);
begin
  DBK32functions.saferQueryPhysicalMemory:=cbsaferPhysicalMemory.checked;
end;

procedure TMainForm.cbPauseWhileScanningClick(Sender: TObject);

begin
  if (cbPauseWhileScanning.Checked) and (processid = getcurrentprocessid) then
  begin
    cbPauseWhileScanning.Checked := False;
    messagedlg(strdontbother, mtError, [mbOK], 0);
  end;
end;

procedure TMainForm.ProcessLabelDblClick(Sender: TObject);
var
  peprocess: dword;
  needed: dword;
  x: dword;
  processInfo: TProcessBasicInformation;

  buf: PChar;
begin
  if formsettings.cbKernelOpenProcess.Checked then
  begin
    if processid = 0 then
      exit;

    if not IsValidHandle(processhandle) then
      if messagedlg(rsTheProcessIsnTFullyOpenedIndicatingAInvalidProcess,
        mtWarning, [mbYes, mbNo], 0) <> mrYes then
        exit;

    peprocess := GetPEProcess(processid);
    ShowMessage('PEProcess=' + IntToHex(peprocess, 8));
    memorybrowser.memoryaddress := peprocess;

  end;
end;

procedure TMainForm.ProcessLabelMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: integer);
begin
  if assigned(newkernelhandler.IsValidHandle) then
  begin
    if (button = mbright) and (DBKLoaded) and newkernelhandler.IsValidHandle(processhandle) then
    begin
      outputdebugstring('(button = mbright) and (DBKLoaded) and IsValidHandle(processhandle)');
      tfrmProcessInfo.Create(self).Show;
    end;
  end
  else
    outputdebugstring('IsValidHandle is unassigned');
end;

procedure TMainForm.cbUnrandomizerClick(Sender: TObject);
begin
  if cbunrandomizer.Checked then
  begin
    if (messagedlg(rsUnrandomizerInfo, mtWarning, [mbYes, mbNo], 0) = mrYes) then
    begin
      unrandomize := tunrandomize.Create(True);
      with unrandomize do
      begin

        progressbar := tprogressbar.Create(self);
        progressbar.AnchorSideLeft.control:=cbunrandomizer;
        progressbar.AnchorSideLeft.side:=asrLeft;

        progressbar.AnchorSideRight.control:=cbunrandomizer;
        progressbar.AnchorSideRight.side:=asrRight;

        progressbar.AnchorSideTop.control:=cbunrandomizer;
        progressbar.AnchorSideTop.side:=asrTop;

        progressbar.AnchorSideBottom.control:=cbunrandomizer;
        progressbar.AnchorSideBottom.side:=asrBottom;

        progressbar.Anchors:=[akTop, akLeft, akRight, akBottom];

        progressbar.parent := self;
        cbunrandomizer.Enabled := False;
        start;
      end;
    end
    else
      cbUnrandomizer.Checked := False;
  end
  else
  begin
    if unrandomize <> nil then
      FreeAndNil(unrandomize);
  end;
end;

procedure TMainForm.cbUnrandomizerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: integer);
begin
  if cbunrandomizer.Checked and (button = mbright) then
  begin
    //show unrandimized addresses
    unrandomize.showaddresses;
  end;
end;


procedure TMainForm.SaveIntialTablesDir(dir: string);
var
  reg: tregistry;
begin
  reg := Tregistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Cheat Engine', True) then
      reg.WriteString('Initial tables dir', dir);

  finally
    reg.Free;
  end;
end;

procedure TMainForm.actOpenExecute(Sender: TObject);
var
  merge: boolean;
  app: word;
  Extension,oldFileName: string;

begin


  merge := False;
  if not autoopen then
    if CheckIfSaved = False then
      exit;


  oldFileName:=Opendialog1.FileName;
  if autoopen or Opendialog1.Execute then
  begin
    SaveIntialTablesDir(extractfilepath(Opendialog1.filename));

    autoopen := False;
    Extension := uppercase(extractfileext(opendialog1.filename));
    if (Extension <> '.XML') and
       {(Extension<>'.PTR') and
       (Extension<>'.AMT') and
       (Extension<>'.GH') and
       (Extension<>'.CET') and
       (Extension<>'.CT2') and
       (Extension<>'.CT3') and    }
      (Extension <> '.CT') and (Extension <> '.CETRAINER') then
      raise Exception.Create(strUnknownExtension);


    if ((addresslist.Count > 0) or (advancedoptions.numberofcodes > 0) or (DissectedStructs.count>0) ) and
      (Extension <> '.EXE') then
    begin
      app := messagedlg(rsDoYouWishToMergeTheCurrentTableWithThisTable,
        mtConfirmation, mbYesNoCancel, 0);
      case app of
        mrCancel: exit;
        mrYes: merge := True;
        mrNo: merge := False;
      end;

    end;

    try
      LoadTable(Opendialog1.filename, merge);
      SaveDialog1.filename:=Opendialog1.filename;

      UserDefinedTableName:=Opendialog1.filename;
      reinterpretaddresses;
    except
      on e:exception do
        MessageDlg('This table failed to load: '+e.message,mtError,[mbok],0);
    end;
  end
  else Opendialog1.FileName:=oldFileName;

  if advancedoptions <> nil then
  begin
    if advancedoptions.codelist2.items.Count > 0 then
    begin
      advancedoptions.Position := podesigned;
      advancedoptions.Left := mainform.left - advancedoptions.Width;
      advancedoptions.Top := mainform.Top + mainform.Height - advancedoptions.Height;

      if (advancedoptions.Left < 0) or
        (advancedoptions.Top + advancedoptions.Height > screen.Height) then
      begin
        advancedoptions.left := 0;
        advancedoptions.Top := screen.Height - advancedoptions.Height;

      end;
      advancedoptions.Show;
    end;
  end;
end;



procedure TMainForm.actSaveExecute(Sender: TObject);
var
  protect: boolean;
  oldFileName: string;
begin
  saveGotCanceled:=true;
  protect := False;
  if (savedialog1.FileName = '') and (opendialog1.filename <> '') then
  begin
    //set the filename the table was opened with to the filename you save as default to
    //and dont forget to change the extension to .CT
    savedialog1.FileName := ChangeFileExt(opendialog1.FileName, '');
  end;


  oldFileName:=Savedialog1.FileName;
  if Savedialog1.Execute then
  begin
    if uppercase(ExtractFileExt(savedialog1.FileName)) = '.CETRAINER' then
      protect := MessageDlg(rsDoYouWantToProtectThisTrainerFileFromEditing,
        mtConfirmation, [mbYes, mbNo], 0) = mrYes;

    savetable(savedialog1.FileName, protect);

    saveGotCanceled:=false;
    opendialog1.FileName := savedialog1.filename;
    SaveIntialTablesDir(extractfilepath(savedialog1.filename));

    UserDefinedTableName:=savedialog1.filename;
  end
  else Savedialog1.FileName:=oldFileName;
end;

procedure TMainForm.actAutoAssembleExecute(Sender: TObject);
begin
  tfrmautoinject.Create(self).Show;
end;

procedure TMainForm.changeScriptCallback(memrec: TMemoryRecord; script: string; changed: boolean);
{
Gets called when a edit script is done
}
begin
  if changed then
    memrec.AutoAssemblerData.script.Text := script;

  memrec.endEdit; //release it so the user can delete it if he/she wants to
end;

procedure TMainForm.AddressListAutoAssemblerEdit(Sender: TObject; memrec: TMemoryRecord);
var
  x: TFrmAutoInject;
  y: array of integer;
begin
  if memrec.AsyncProcessing then exit;

  if memrec.isBeingEdited then
  begin
    if memrec.autoAssembleWindow<>nil then
    begin
      if memrec.autoAssembleWindow.WindowState<>wsNormal then
        memrec.autoAssembleWindow.WindowState:=wsNormal;

      memrec.autoAssembleWindow.show;
      memrec.autoAssembleWindow.BringToFront;
    end;
  end
  else
  begin
    x := tfrmautoinject.Create(self);
    x.memrec:=memrec;
    with x do
    begin
      //name:='AAEditScript';
      new1.Enabled := False;

      editscript := True;
      editscript2 := True;


      memrec.beginEdit;
      memrec.autoAssembleWindow := x;
      callbackroutine := changeScriptCallback;

      assemblescreen.Text := memrec.AutoAssemblerData.script.Text;

      setlength(y, 0);
      loadformposition(x, y);

      Caption := Format(rsAutoAssembleEdit, [memrec.Description]);
      Show;

    end;

  end;

end;

procedure TMainForm.miAsyncScriptClick(Sender: TObject);
begin
  if (addresslist.selectedRecord <> nil) and
    (addresslist.selectedRecord.VarType = vtAutoAssembler) then
     addresslist.selectedRecord.Async:=miAsyncScript.Checked;
end;


procedure TMainForm.Changescript1Click(Sender: TObject);
begin
  if (addresslist.selectedRecord <> nil) and
    (addresslist.selectedRecord.VarType = vtAutoAssembler) then
    AddressListAutoAssemblerEdit(addresslist, addresslist.selectedRecord);
end;

procedure TMainForm.Forcerechecksymbols1Click(Sender: TObject);
begin
  symhandler.reinitialize;
  symhandler.waitforsymbolsloaded;
//  addresslist.needsToReinterpret := True;
  addresslist.reinterpretAddresses;
end;

procedure TMainForm.Edit;
var
  frmPasteTableentry: TfrmPasteTableentry;
  replace_find: string;
  replace_with: string;
  changeoffsetstring: string;
  changeoffset, x: int64;
  i, j: integer;
  hasselected: boolean;
begin
  if addresslist.Count = 0 then
    exit;

  frmPasteTableentry := TfrmPasteTableentry.Create(self);
  try
    frmPasteTableentry.Caption := rsEditAddresses;
    frmPasteTableentry.Button1.Caption := rsEdit;

    if frmpastetableentry.showmodal = mrCancel then
      exit;
    replace_find := frmpastetableentry.edtFind.Text;
    replace_with := frmpastetableentry.edtReplace.Text;

    changeoffsetstring := '$' + stringreplace(frmpastetableentry.edtOffset.Text,
      '-', '-$', [rfReplaceAll]);
    changeoffsetstring := stringreplace(changeoffsetstring, '$-', '-', [rfReplaceAll]);

    try
      changeoffset := StrToInt64(changeoffsetstring);
    except
      changeoffset := 0;
    end;
  finally
    frmPasteTableentry.Free;
  end;


  hasselected := False;
  for i := 0 to addresslist.Count - 1 do
  begin
    if addresslist[i].isselected then
    begin
      hasselected := True;
      break;
    end;
  end;

  for i := 0 to addresslist.Count - 1 do
  begin
    if (hasselected and addresslist[i].isSelected) or (not hasselected) then
    begin
      addresslist[i].Description :=
        StringReplace(addresslist[i].Description, replace_find, replace_with,
        [rfReplaceAll, rfIgnoreCase]);

      try
        x := symhandler.getAddressFromName(addresslist[i].interpretableaddress);
        x := x + changeoffset;
        addresslist[i].interpretableaddress := symhandler.getNameFromAddress(x, True, True)
      except

      end;
    end;
  end;
end;

procedure TMainForm.Smarteditaddresses1Click(Sender: TObject);
begin
  edit;
end;


procedure TMainForm.miGeneratePointermapClick(Sender: TObject);
var
  frmPointerScanner: TfrmPointerScanner;
  oldSettingsForm: tfrmpointerscannersettings;
begin
  frmPointerScanner := tfrmpointerscanner.Create(self);
  frmPointerScanner.Show;

  oldSettingsForm:=frmpointerscannersettings;

  frmpointerscannersettings := tfrmpointerscannersettings.Create(self);

  if processhandler.is64Bit then
    frmpointerscannersettings.edtReverseStop.text:='00007FFFFFFFFFFF'
  else
  begin
    if Is64bitOS then
      frmpointerscannersettings.edtReverseStop.text:='FFFFFFFF'
    else
      frmpointerscannersettings.edtReverseStop.text:='7FFFFFFF';
  end;

  frmpointerscannersettings.CbAlligned.checked:=true;
  frmpointerscannersettings.cbConnectToNode.checked:=false;

  frmpointerscannersettings.rbGeneratePointermap.checked:=true;
  frmpointerscannersettings.btnOk.Click;

  frmPointerScanner.SkipNextScanSettings:=true;
  frmPointerScanner.Method3Fastspeedandaveragememoryusage1.Click;

  freeandnil(frmpointerscannersettings);

  frmpointerscannersettings:=oldSettingsForm;
end;

procedure TMainForm.Pointerscanforthisaddress1Click(Sender: TObject);
var
  address: ptrUint;
  Count: dword;
  j: integer;
  check: boolean;
  i: integer;
  findpointeroffsets: boolean;

  frmPointerScanner: TfrmPointerScanner;
  memrec: TMemoryRecord;
begin
  if addresslist.selectedRecord <> nil then
  begin
    memrec := addresslist.selectedRecord;
    findpointeroffsets := False;


    address := memrec.GetRealAddress;


    //default
    frmPointerScanner := tfrmpointerscanner.Create(self);
    frmPointerScanner.Show;

    if frmpointerscannersettings = nil then //used over and over
      frmpointerscannersettings := tfrmpointerscannersettings.Create(self);

    frmpointerscannersettings.cbAddress.Text := inttohex(address, 8);
    frmpointerscannersettings.cbCompareToOtherPointermaps.Checked:=false;
    frmpointerscannersettings.cbUseLoadedPointermap.checked:=false;

    if findpointeroffsets then
    begin
      //create and fill in the offset list

      frmpointerscannersettings.cbMustEndWithSpecificOffset.Checked := True;
      TOffsetEntry(frmpointerscannersettings.offsetlist[0]).offset := memrec.offsets[0].offset;

      for i := 1 to memrec.offsetcount - 1 do
      begin
        frmpointerscannersettings.btnAddOffset.Click;
        TOffsetEntry(frmpointerscannersettings.offsetlist[i]).offset := memrec.offsets[i].offset;
      end;
    end;

    frmpointerscannersettings.rbFindAddress.checked:=true;
    frmPointerScanner.Method3Fastspeedandaveragememoryusage1.Click;

  end;
end;

procedure testx(arg1: pointer; arg2: pointer; arg3: pointer); stdcall;
begin

end;

procedure TMainForm.Label53Click(Sender: TObject);
begin

end;

procedure TMainForm.OnToolsClick(Sender: TObject);
begin
  shellexecute(0, 'open', PChar(
    formsettings.lvTools.Items[TMenuItem(Sender).Tag].SubItems[0]), nil, nil, SW_SHOW);
end;

procedure TMainForm.plugintype5click(Sender: TObject);
var
  x: TPluginfunctionType5;
begin
  x := TPluginfunctionType5(tmenuitem(Sender).Tag);
  if x <> nil then
    x.callback();
end;

procedure TMainForm.plugintype0click(Sender: TObject);
var
  selectedrecord: PPlugin0_SelectedRecord;
var
  x: TPluginfunctionType0;
  interpretableaddress: string[255];
  description: string[255];
  i: integer;
  offsets: PDwordArray;

  a, b, c, d, e, f, g, h, j: dword;

  t: TVariableType;
begin
  if addresslist.selectedRecord = nil then
    exit;

  interpretableaddress := ' ';
  description := ' ';


  getmem(selectedrecord, sizeof(TPlugin0_SelectedRecord));
  //fill it with data

  interpretableaddress := addresslist.selectedRecord.interpretableaddress;

  selectedrecord.interpretedaddress := @interpretableaddress[1];

  selectedrecord.address := addresslist.selectedRecord.getrealAddress;
  selectedrecord.ispointer := addresslist.selectedRecord.IsPointer;
  selectedrecord.countoffsets := addresslist.selectedRecord.offsetCount;

  getmem(offsets, selectedrecord.countoffsets * 4); //don't forget to free
  selectedrecord.offsets := offsets;
  for i := 0 to selectedrecord.countoffsets - 1 do
    selectedrecord.offsets[i] := addresslist.selectedRecord.offsets[i].offset;

  description := addresslist.selectedRecord.Description;
  selectedrecord.description := @description[1];

  selectedrecord.valuetype := integer(addresslist.selectedRecord.VarType);
  selectedrecord.size := addresslist.selectedRecord.bytesize;



  x := TPluginfunctionType0(tmenuitem(Sender).Tag);
  if x <> nil then
  begin

    interpretableaddress[length(interpretableaddress) + 1] := #0;
    description[length(description) + 1] := #0;

    if x.callback(selectedrecord) then
    begin

      interpretableaddress[255] := #0;
      description[255] := #0;

      pbyte(@interpretableaddress[0])^ := StrLen(@interpretableaddress[1]);
      pbyte(@description[0])^ := StrLen(@description[1]);

      addresslist.selectedRecord.interpretableaddress := interpretableaddress;

      addresslist.selectedRecord.Description := description;
      byte(t) := selectedrecord.valuetype;
      addresslist.selectedRecord.VarType := t;

      //load back and free memory
      freememandnil(offsets);
      //using my own var instead the user is lame enough to mess up the pointer
      addresslist.selectedRecord.ReinterpretAddress;
    end;
    //showmessage(inttohex(dword(@x.callback),8));
  end;


  addresslist.selectedRecord.refresh;

end;


//------------------foundlist------------------

procedure TMainForm.Foundlist3Data(Sender: TObject; Item: TListItem);
var
  extra: dword;
  Value, PreviousValue: string;
  Address: ptruint;
  addressString: string;
  valuetype: TVariableType;

  ssVt: TVariableType;
  p: pointer;
  invalid: boolean;
  ct: TCustomType;

  part: integer;
  error: string;

  hexadecimal: boolean;
begin

  //put in data
  ct:=foundlist.CustomType;

  part:=0;



  try
    valuetype:=foundlist.vartype;
    address := foundlist.GetAddress(item.Index, extra, Value);

    if (address=0) then
    begin
      item.Caption := rsProcessing;
      item.subitems.add(rsProcessing);
      item.subitems.add(rsProcessing);
      exit;
    end;


    AddressString:=IntToHex(address,8);

    hexadecimal:=foundlist.isHexadecimal;

    if foundlistDisplayOverride<>0 then
    begin
      if foundlistDisplayOverride=7 then
        hexadecimal:=not hexadecimal
      else
      begin
        case foundlistDisplayOverride of
          1: valuetype:=vtByte;
          2: valuetype:=vtWord;
          3: valuetype:=vtDword;
          4: valuetype:=vtQword;
          5: valuetype:=vtSingle;
          6: valuetype:=vtDouble;
        end;
        hexadecimal:=false;
      end;

      if foundlistDisplayOverride>=1000 then
      begin
        if (foundlistDisplayOverride-1000)<customTypes.count then
        begin

          if TCustomType(customTypes[foundlistDisplayOverride-1000]).bytesize<=memscan.Getbinarysize then
          begin
            valuetype:=vtCustom;
            ct:=TCustomType(customTypes[foundlistDisplayOverride-1000]);
          end;
        end;
      end;

      if valuetype=vtAll then
        value:=readAndParseAddress(address, TVariableType(extra), ct, hexadecimal)
      else
        value:=readAndParseAddress(address, valuetype, ct, hexadecimal);
    end;


    PreviousValue:='';


    if foundlist.vartype = vtBinary then //binary
    begin
      AddressString := AddressString + '^' + IntToStr(extra);
    end
    else
    if foundlist.vartype = vtAll then //all
    begin
      if extra >= $1000 then
      begin
        ct:=TCustomType(customTypes[extra - $1000]);
        valuetype:=vtCustom;
        AddressString := AddressString + ':' + ct.Name;
      end
      else
      begin
        valuetype := TVariableType(extra);

        //here valuetype is stored using the new method
        case valuetype of
          vtByte: AddressString := AddressString + ':1';
          vtWord: AddressString := AddressString + ':2';
          vtDword: AddressString := AddressString + ':4';
          vtQword: AddressString := AddressString + ':8';
          vtSingle: AddressString := AddressString + ':s';
          vtDouble: AddressString := AddressString + ':d';
        end;
      end;
    end;

    if miShowPreviousValue.checked and (PreviousResults<>nil) then
    begin
      //get the previous value of this entry
      invalid:=false;
      case foundlist.vartype of
        vtByte: ssVt:=vtbyte;
        vtWord: ssVt:=vtword;
        vtDword: ssVt:=vtdword;
        vtSingle: ssVt:=vtsingle;
        vtDouble: ssVt:=vtdouble;
        vtQword: ssVt:=vtQword;
        vtCustom: ssVt:=vtCustom;
        vtAll: ssVt:=vtall;
        else
          invalid:=true;

      end;

      if not invalid then
      begin
        p:=PreviousResults.getpointertoaddress(address, ssvt, ct);
        if p=nil then
        begin
          if PreviousResults.lastFail=1 then
            previousvalue:=rsFileInUse
          else
            previousvalue:=rsBusy+' : '+inttostr(PreviousResults.lastFail)
        end
        else
          previousvalue:=readAndParsePointer(address, p, valuetype, ct, hexadecimal, foundlist.isSigned);
      end;
    end;


    part:=3; //meh


    item.Caption := AddressString;
    item.subitems.add(Value);
    item.subitems.add(previousvalue);


  except
    on e: exception do
    begin
    //ShowMessage(IntToStr(item.index));

      error:=rsCEError+inttostr(item.index)+rsPart+inttostr(part)+':'+e.message;

      if part in [0,3] then
      begin
        item.Caption:=error;
        item.subitems.add(e.Message);
        item.subitems.add('');
      end;

      if part=1 then
      begin
        item.Caption := AddressString;
        item.subitems.add(error);
        item.subitems.add(e.Message);
      end;

      if part=2 then
      begin
        item.Caption := AddressString;
        item.subitems.add(Value);
        item.subitems.add(error);
      end;
    end;
  end;
end;

procedure TMainForm.UpdateFoundlisttimerTimer(Sender: TObject);
begin

  if foundlist <> nil then
  begin
    foundlist.RefetchValueList;
    foundlist3.Refresh;
  end;
end;

procedure TMainForm.Foundlist3KeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
var
  i: integer;
begin

  foundlistpopupPopup(sender);
  if ((key = Ord('A')) and (ssctrl in Shift) and not (ssalt in Shift)) then
  begin
    //select all
    if foundlist3.Items.Count < 5000 then
    begin
      for i := 0 to foundlist3.items.Count - 1 do
        foundlist3.Items[i].Selected := True;

      //      foundlist3.SelectAll;
    end;
  end;
end;


procedure TMainForm.miTutorialClick(Sender: TObject);
begin
  shellexecute(0, 'open', pchar(cheatenginedir+'Tutorial-i386.exe'), nil, nil, sw_show);
end;

procedure TMainForm.miFlFindWhatAccessesClick(Sender: TObject);
var
  address: ptrUint;
  res: word;
begin
  if foundlist3.Selected<>nil then
  begin
    address:=foundlist.GetAddress(foundlist3.Selected.Index);
    if (not startdebuggerifneeded) then
      exit;

    DebuggerThread.FindWhatAccesses(address, memscan.Getbinarysize div 8);
  end;
end;

procedure TMainForm.miFlFindWhatWritesClick(Sender: TObject);
var
  address: ptrUint;
  extra: dword;
  res: word;
begin
  if foundlist3.Selected<>nil then
  begin
    address:=foundlist.GetAddress(foundlist3.Selected.Index);
    if (not startdebuggerifneeded) then
      exit;

    DebuggerThread.FindWhatWrites(address, memscan.Getbinarysize div 8);
  end;

end;

procedure TMainForm.miSaveFileClick(Sender: TObject);
begin
  if Processwindow = nil then
    ProcessWindow := TProcessWindow.Create(application);

  if ProcessWindow.opendialog2.Execute then
    Filehandler.CommitChanges(ProcessWindow.opendialog2.filename);
end;

procedure TMainForm.miChangeValueBackClick(Sender: TObject);
var
  currentlySelectedSavedResultname: string;
  s: tstringlist;
  i: integer;
  a: ptruint;
  p: pointer;

  bytesize: integer;
  x: ptruint;

  savedscan: TSavedScanHandler;
begin
  //show a list of possible options. Previous, last scan, savedscan
  if memscan=nil then exit;

  bytesize:=memscan.Getbinarysize div 8;
  if bytesize=0 then exit;

  s:=tstringlist.create();

  memscan.getsavedresults(s);
  s.insert(0,'Last Scan');

  i:=ShowSelectionList(self,'Previous value liss','Select the saved results you wish to use',s,currentlySelectedSavedResultname);
  s.free;
  if i=-1 then exit;
  if i=0 then currentlySelectedSavedResultname:='TMP';

  savedscan:=TSavedScanHandler.create(memscan.getScanFolder, currentlySelectedSavedResultname);
  savedscan.AllowNotFound:=true;
  savedscan.AllowRandomAccess:=true;

  try
    for i:=0 to foundlist3.items.Count-1 do
    begin
      if foundlist3.Items[i].Selected then
      begin
        a:=foundlist.GetAddress(i);
        p:=savedscan.getpointertoaddress(a, memscan.VarType,memscan.CustomType);

        if p<>nil then
          WriteProcessMemory(processhandle, pointer(a),p,bytesize,x);
      end;
    end;
  finally
    savedscan.free;
  end;
end;



procedure TMainForm.miChangeValueClick(Sender: TObject);
var
  a:ptruint;
  extra: dword;
  value, newvalue: string;
  i: integer;
  vt: TVariableType;
  customtype: TCustomType;
begin
  customtype:=nil;
  if foundlist3.Selected<>nil then
  begin
    foundlist.GetAddress(foundlist3.Selected.Index, extra, Value);

    if InputQuery(rsChangeValue, rsGiveTheNewValueForTheSelectedAddressEs, value) then
    begin
      newvalue:=value;
      for i:=0 to foundlist3.items.Count-1 do
      begin
        if foundlist3.Items[i].Selected then
        begin
          a:=foundlist.GetAddress(i, extra, Value);

          if foundlist.vartype=vtAll then  //all, extra contains the vartype
          begin
            if extra<$1000 then
            begin
              vt:=TVariableType(extra);
            end
            else
            begin //custom type
              vt:=vtCustom;
              customtype:=tcustomtype(customTypes[extra-$1000]);
            end;
          end
          else
            vt:=foundlist.vartype;

          if (vt=vtString) and (cbUnicode.checked) then
            vt:=vtUnicodeString;

          ParseStringAndWriteToAddress(newvalue, a, vt, foundlist.isHexadecimal, customtype);

        end;

      end;

    end;

  end;


end;

var
  _us: string;



var
  advapi: thandle;
  tu: unicodestring;



procedure TMainForm.d3dclicktest(overlayid: integer; x, y: integer);
var
  w, h: integer;
begin
  w := d3dhook.getwidth;
  h := d3dhook.getheight;

  ShowMessage(rsOverlay + IntToStr(overlayid) + rsWasClickedAtPositon +
    IntToStr(x) + ',' + IntToStr(y) + rsWidth + IntToStr(w) + rsHeight + IntToStr(h));
end;





procedure TMainForm.Browsethismemoryregioninthedisassembler1Click(Sender: TObject);
var
  a, b: dword;
  s: string;
begin
  if (foundlist3.ItemIndex <> -1) then
  begin
    memorybrowser.disassemblerview.SelectedAddress :=
      foundlist.GetAddress(foundlist3.ItemIndex, b, s);
    memorybrowser.Show;
  end;
end;

procedure TAutoAttachThread.autoattachcheck;
begin
  MainForm.autoattachcheck(CurrentProcessList);
end;

constructor TAutoAttachThread.Create(CreateSuspended: boolean);
begin
  Interval:=2000;
  CurrentProcessList:=TStringList.Create;
  inherited Create(CreateSuspended);
end;

procedure TAutoAttachThread.Execute;
begin
  while not terminated do
  begin
    if ((MainForm.autoattachlist = nil) or (formsettings = nil) or (MainForm.extraautoattachlist = nil)) or
       ((MainForm.autoattachlist.Count+MainForm.extraautoattachlist.Count)<1) or
       ((not formsettings.cbAlwaysAutoAttach.Checked) and ((processhandle <> 0) or (processid <> 0))) then
    begin
      sleep(Interval);
      continue;
    end;

    getprocesslist(CurrentProcessList,false,true);
    synchronize(autoattachcheck);
    sleep(Interval);
  end;
end;

procedure TMainForm.autoattachcheck(pl: TStringList = nil);
var
  i, j, k: integer;
  newPID: dword;
  a: string;
  p: string;

  oldpid: dword;
  oldphandle: thandle;
  attachlist: TStringList;
begin
  attachlist := TStringList.Create;
  try
    attachlist.AddStrings(autoattachlist);
    attachlist.AddStrings(extraautoattachlist);


    if attachlist.Count > 0 then
    begin
      //in case there is no processwatcher this timer will be used to enumerate the processlist every 2 seconds
      if pl=nil then
      begin
        pl := TStringList.Create;
        getprocesslist(pl,false,true);
      end;

      try
        for i := 0 to attachlist.Count - 1 do
        begin
          a := uppercase(trim(attachlist.Strings[i]));
          for j := pl.Count - 1 downto 0 do //can't do indexof
          begin

            p := uppercase(pl.strings[j]);
            if pos(a, p) = 10 then
            begin
              //the process is found
              p := '$' + copy(p, 1, 8);
              val(p, newPID, k);
              if k = 0 then
              begin
                if ProcessHandler.processid = newPID then
                  exit; //already attached to the newest one

                oldpid := ProcessHandler.processid;
                oldphandle := processhandler.processhandle;

                ProcessHandler.processid := newPID;
                unpause;
                DetachIfPossible;


                MainForm.ProcessLabel.Caption := pl.strings[j];
                Open_Process;
                enablegui(False);

                openProcessEpilogue('', oldpid, oldphandle, True);

                symhandler.reinitialize;
                reinterpretaddresses;
                exit;
              end;
            end;
          end;

        end;
        //  pl.IndexOf(autoattachlist.items[i]);

      finally
        cleanProcessList(pl);
      end;

    end;


  finally
    attachlist.Free;
  end;
end;

procedure TMainForm.AutoAttachTimerTimer(Sender: TObject);
begin
  if (autoattachlist = nil) or (formsettings = nil) or (extraautoattachlist = nil) then
    exit;

  if (not formsettings.cbAlwaysAutoAttach.Checked) and
    ((processhandle <> 0) or (processid <> 0)) then
    exit;

  autoattachcheck;
end;



procedure TMainForm.btnFirstClick(Sender: TObject);
var
  svalue2: string;
  percentage: boolean;
  fastscanmethod: TFastscanmethod;
begin
  QueryPerformanceCounter(scantimestart);

  if PreviousResults<>nil then
    freeandnil(PreviousResults);

  if (memscan=nil) or (foundlist=nil) then raise exception.create(rsUnableToScanFixYourScanSettings);

  foundlist.Deinitialize; //unlock file handles



  if cbpercentage <> nil then
    percentage := cbpercentage.Checked
  else
    percentage := False;


  if btnFirst.tag = 0 then
  begin


    ProgressBar.min := 0;
    ProgressBar.max := 1000;
    ProgressBar.position := 0;

    if scanvalue2 <> nil then
      svalue2 := scanvalue2.Text
    else
      svalue2 := '';

    lastscantype := scantype.ItemIndex;

    if cbPauseWhileScanning.Checked then
    begin
      advancedoptions.Pausebutton.down := True;
      advancedoptions.Pausebutton.Click;
    end;

    case cbWritable.State of
      cbUnchecked: memscan.scanWritable := scanExclude;
      cbChecked: memscan.scanWritable := scanInclude;
      cbGrayed: memscan.scanWritable := scanDontCare;
    end;

    case cbExecutable.State of
      cbUnchecked: memscan.scanExecutable := scanExclude;
      cbChecked: memscan.scanExecutable := scanInclude;
      cbGrayed: memscan.scanExecutable := scanDontCare;
    end;

    case cbCopyOnWrite.State of
      cbUnchecked: memscan.scanCopyOnWrite := scanExclude;
      cbChecked: memscan.scanCopyOnWrite := scanInclude;
      cbGrayed: memscan.scanCopyOnWrite := scanDontCare;
    end;

    if cbfastscan.Checked then
    begin
      if rbFsmAligned.Checked then
        fastscanmethod := fsmAligned
      else
        fastscanmethod := fsmLastDigits;
    end
    else
      fastscanmethod := fsmNotAligned;

    memscan.floatscanWithoutExponents:=cbFloatSimple.checked;
    memscan.inversescan:=cbNot.Checked and cbnot.Visible;

    memscan.codePage:=cbCodePage.checked;
    if ScanTabList <> nil then
      ScanTabList.Enabled := False;

    memscan.firstscan(GetScanType2, getVarType2, roundingtype,
      scanvalue.Text, svalue2, scanStart, scanStop,
      cbHexadecimal.Checked, rbdec.Checked, cbunicode.Checked, cbCaseSensitive.Checked, fastscanmethod, edtAlignment.Text,
      TCustomType(vartype.items.objects[vartype.ItemIndex]));

    DisableGui;

    SpawnCancelButton;

  end
  else if btnFirst.tag = 2 then
  begin
    //btnNewScan
    btnFirst.Tag := 0;
    donewscan;
    memscan.newscan; //cleanup memory and terminate all background threads
  end;
end;

procedure TMainForm.ScanDone(sender: TObject);
var
  i: integer;
  canceled: boolean;
  actuallyshown: double;
  error: boolean;
  previous: string;

  c: qword;

  scantime: qword;
begin
  QueryPerformanceCounter(scantimefinish);
  scantime:=scantimefinish-scantimestart;

{$ifdef SCANPERF}
  if ssCtrl in GetKeyShiftState then
    showmessage(inttostr(scantime));
{$endif}


  if ScanTabList <> nil then
    ScanTabList.Enabled := True;

  i := 0;
  canceled := False;

  btnFirst.Tag := 2;
  btnFirst.Caption := rsScan;
  btnNext.tag := 0;
  ProgressBar.Position := 0;


  SetProgressState(tbpsNone);


  error:=tmemscan(sender).hasError;

  if tmemscan(sender).hasError then
  begin
    error:=true;
    messagedlg(Format(rsScanError, [memscan.GetErrorString]), mtError, [mbOK], 0);
  end
  else
    error:=false;


  enablegui(memscan.LastScanType = stNextScan);
  destroyCancelButton;



  foundlist.Initialize(getvartype, memscan.Getbinarysize, cbHexadecimal.Checked,
    formsettings.cbShowAsSigned.Checked, not rbBit.Checked, cbunicode.Checked,
    TCustomType(VarType.items.objects[vartype.ItemIndex]));

  c:=memscan.GetFoundCount;
  foundcount := c;

  if PreviousResults<>nil then
    freeandnil(PreviousResults);

  if not compareToSavedScan then
    previous:='TMP'
  else
    previous:=currentlySelectedSavedResultname;


  try
    PreviousResults:=TSavedScanHandler.create(memscan.getScanFolder, previous);
    PreviousResults.AllowNotFound:=true;
    PreviousResults.AllowRandomAccess:=true;
  except
    PreviousResults:=nil;
  end;


  if (foundlist3.items.Count <> foundcount) and (not foundlist.isUnknownInitialValue) then
  begin
    actuallyshown := foundlist3.items.Count;
    foundcountlabel.Caption := foundcountlabel.Caption + ' (' + rsShown +
      ': ' + Format('%.0n', [actuallyshown]) + ')';
  end;

  if memscan.lastscantype = stFirstScan then
  begin
    //firstscan Epilogue
    setGbScanOptionsEnabled(False);

    vartype.Enabled := False;
    btnNextScan.Enabled := True;
    btnNewScan.Caption := strNewScan;
  end;

  beep;
  //let the blind user know the scan has finished (See, I'm thinking about the visually impeared users...)

  ProgressBar.Position := 0;
  UpdateFoundlisttimer.Enabled := True;

  Scantype.ItemIndex := lastscantype;
  UpdateScanType;

  if cbpercentage <> nil then
    cbPercentageOnChange(cbpercentage);


  scanepilogue(canceled);

  if error and (memscan.lastscantype = stFirstScan) then //firstscan failed
    btnNewScan.Click;
end;

procedure TMainForm.CancelbuttonClick(Sender: TObject);
begin
  if cancelbutton.tag = 0 then
  begin
    cancelbutton.Caption := rsTerminatingScan;
    cancelbutton.Enabled := False;
    cancelbutton.Tag := 1; //force termination
    cancelbutton.Hint := rsThisButtonWillForceCancelAScanExpectMemoryLeaks;
    cancelbutton.ParentShowHint := False;
    cancelbutton.ShowHint := True;
    memscan.terminatescan(False);

    cancelbuttonenabler.Enabled := False;
    cancelbuttonenabler.interval := 8000; //8 seconds
    cancelbuttonenabler.tag := 1;
    cancelbuttonenabler.Enabled := True;
  end
  else
  begin
    //force it. It took too long
    memscan.TerminateScan(True);
  end;
end;

procedure TMainForm.CancelbuttonenablerInterval(Sender: TObject);
begin
  if cancelbutton <> nil then
    cancelbutton.Enabled := True;

  if cancelbutton.Tag = 1 then
    cancelbutton.Caption := rsForceTermination;
  TTimer(Sender).Enabled := False;
end;


procedure TMainForm.btnNextClick(Sender: TObject);
var
  svalue2: string;
  estimateddiskspaceneeded: qword;
  diskspacefree, totaldiskspace: int64;
  totaldiskspacefree: LARGE_INTEGER;
  percentage: boolean;
begin
 { estimateddiskspaceneeded:=foundcount*8*3;
  GetDiskFreeSpaceEx(pchar(memscan.ScanresultFolder), diskspacefree, totaldiskspace,@totaldiskspacefree);


  if estimateddiskspaceneeded>diskspacefree then
    if MessageDlg(rsYouAreLowOnDiskspaceOnTheFolderWhereTheScanresults, mtwarning, [mbyes, mbno], 0)<>mryes then exit;
     }



  if cbpercentage <> nil then
    percentage := cbPercentage.Checked
  else
    percentage := False;

  if PreviousResults<>nil then
    freeandnil(PreviousResults);

  foundlist.Deinitialize; //unlock file handles

  if cbPauseWhileScanning.Checked then
  begin
    advancedoptions.Pausebutton.down := True;
    advancedoptions.Pausebutton.Click;
  end;

  ProgressBar.min := 0;
  ProgressBar.max := 1000;
  ProgressBar.position := 0;


  if scanvalue2 <> nil then
    svalue2 := scanvalue2.Text
  else
    svalue2 := '';

  lastscantype := scantype.ItemIndex;

  memscan.floatscanWithoutExponents:=cbFloatSimple.checked;
  memscan.inverseScan:=cbNot.Checked and cbnot.Visible;
  memscan.codePage:=cbCodePage.checked;

  if ScanTabList <> nil then
    ScanTabList.Enabled := False;

  memscan.nextscan(GetScanType2, roundingtype, scanvalue.Text,
    svalue2, cbHexadecimal.Checked, rbdec.Checked,
    cbunicode.Checked, cbCaseSensitive.Checked, percentage, compareToSavedScan,
    currentlySelectedSavedResultname);
  DisableGui;
  SpawnCancelButton;
end;

procedure TMainForm.scanEpilogue(canceled: boolean);
var
  vtype: TVariableType;
  i: integer;
  bytes: tbytes;
begin

  vtype := getvartype;
  if not canceled then
  begin
    case vtype of
      vtBinary: i := memscan.getbinarysize;
      vtString: i := length(scanvalue.Text);
      vtByteArray: //array of byte
      begin
        setlength(bytes, 0);
        try
          ConvertStringToBytes(scanvalue.Text, cbHexadecimal.Checked, bytes);
          i := length(bytes);
        except
          i := 1;
        end;
        setlength(bytes, 0);
      end;
    end;
    foundlist.Initialize(vtype, i, cbHexadecimal.Checked,
      formsettings.cbShowAsSigned.Checked, not rbBit.Checked, cbunicode.Checked,
      memscan.CustomType);
  end
  else
    foundlist.Initialize(vtype, memscan.CustomType);
  //failed scan, just reopen the addressfile





  try
    if scanvalue.Visible and scanvalue.Enabled then
    begin
      scanvalue.SetFocus;
      scanvalue.SelectAll;
    end
    else
    if not canceled then
    begin
      btnNextScan.SetFocus;
    end;
  except

  end;



  if cbPauseWhileScanning.Checked then
  begin
    advancedoptions.Pausebutton.down := False; //resume
    advancedoptions.Pausebutton.Click;
  end;

end;


procedure TMainForm.FormDestroy(Sender: TObject);
var
  i: integer;
  oldscanstate: PScanState;
  x: array of integer;
  reg: tregistry;
begin
  if flashprocessbutton<>nil then
  begin
    flashprocessbutton.Terminate;
    flashprocessbutton.WaitFor;
    flashprocessbutton.Free;
  end;

  setlength(x,7);
  x[0]:=addresslist.headers.Sections[0].Width;
  x[1]:=addresslist.headers.Sections[1].Width;
  x[2]:=addresslist.headers.Sections[2].Width;
  x[3]:=addresslist.headers.Sections[3].Width;
  x[4]:=addresslist.headers.Sections[4].Width;
  x[5]:=panel5.Height;
  x[6]:=foundlist3.columns[0].Width;

  saveformposition(self, x);

  cereg.writeBool('Debug', miEnableLCLDebug.checked);


  if foundlist <> nil then
    foundlist.Deinitialize;

  if addresslist <> nil then
    FreeAndNil(addresslist);

  if scantablist = nil then
    if memscan <> nil then
      FreeAndNil(memscan);

  if scantablist <> nil then
  begin
    for i := 0 to scantablist.Count - 1 do
    begin
      if scantablist.SelectedTab <> i then
      begin
        oldscanstate := scantablist.TabData[i];
        freeandnil(oldscanstate.foundlist);
        freeandnil(oldscanstate.memscan);
        freememandnil(oldscanstate);
      end;
    end;
    FreeAndNil(scantablist);
  end;

end;

procedure TMainForm.tbSpeedChange(Sender: TObject);
var
  x: integer;
  y: single;
begin
  x := tbSpeed.position;
  case x of
    0: y := 0;
    1: y := 0.25;
    2: y := 0.5;
    3: y := 1;
    4: y := 2;
    5: y := 5;
    6: y := 10;
    7: y := 20;
    8: y := 50;
    9: y := 100;
    10: y := 200;
    11: y := 500;
    else
      y := 1;
  end;

  if x>=3 then
    editSH2.Text := format('%.0f', [y])
  else
  if x>=2 then
    editSH2.Text := format('%.1f', [y])
  else
  if x<2 then
    editSH2.Text := format('%.2f', [y]);
end;

procedure TMainForm.btnSetSpeedhack2Click(Sender: TObject);
var
  newspeed: single;
  fs: Tformatsettings;
  error: boolean;
begin
  error := False;
  try
    newspeed := StrToFloat(editsh2.Text);
  except
    fs := DefaultFormatSettings;
    try
      newspeed := StrToFloat(editsh2.Text, fs);
    except
      error := True;
    end;
  end;

  if error or IsInfinite(newspeed) or IsNan(newspeed) then
    raise Exception.Create(Format(rsIsNotAValidSpeed, [editSH2.Text]));

  if speedHack <> nil then
  begin

    if speedhack.processid<>processid then
    begin
      //the process switched
      FreeAndNil(speedhack);  //recreate
      speedhack := TSpeedhack.Create;
    end;

    speedhack.setSpeed(newspeed);
  end;
end;

procedure TMainForm.cbSpeedhackChange(Sender: TObject);
begin
  if cbSpeedhack.Checked then
  begin
    try
      if speedhack <> nil then
        FreeAndNil(speedhack);

      speedhack := TSpeedhack.Create;
    except
      on e: Exception do
      begin
        cbSpeedhack.Checked := False;
        raise Exception.Create(e.Message);
      end;
    end;
  end
  else
  begin
    if speedhack <> nil then
      FreeAndNil(speedhack);
  end;

  panel14.Visible := cbSpeedhack.Checked;
end;

{--------Processlist menuitem--------}
//var
//  il: TImageList;


procedure TMainForm.Process1Click(Sender: TObject);

var
  sl: TStringList;
  mi: array of TMenuItem;
  currentmi: TMenuItemExtra;
  i, j: integer;

  tempicon: Graphics.TIcon;
  tempp: tpicture;

begin
  //fill with processlist
 // if il = nil then
 //   il := TImageList.Create(self);

 // il.clear;


  sl := TStringList.Create;

  try
    GetProcessList(sl);
    for i := process1.Count - 1 downto 3 do
      process1.Items[i].Free;

    setlength(mi, sl.Count);
    for i := 0 to sl.Count - 1 do
    begin
      j := sl.Count - 1 - i;
      currentmi := TMenuItemExtra.Create(self);
      currentmi.Caption := sl[i];
      currentmi.Default := dword(sl.Objects[i]) = ProcessID;
      currentmi.Data := pointer(ptrUint(PProcessListInfo(sl.Objects[i])^.processid));
      currentmi.OnClick := ProcessItemClick;


      if PProcessListInfo(sl.Objects[i])^.processIcon > 0 then
      begin
        tempicon := Graphics.TIcon.Create;
        tempicon.handle := PProcessListInfo(sl.Objects[i])^.processIcon;

        tempp:=TPicture.create;
        tempp.Icon:=tempicon;
        currentmi.Bitmap:=tempp.bitmap;

        tempp.free;
        tempicon.free;
      end
      else
        currentmi.ImageIndex := -1;

      mi[j] := currentmi;
      process1.Add(currentmi);
    end;

  finally
    cleanProcessList(sl);
    sl.Free;
  end;




end;

procedure TMainForm.ProcessItemClick(Sender: TObject);
var
  pid: dword;
  oldprocess: Dword;
  oldprocesshandle: thandle;
  oldprocessname: string;
begin

  if openprocessPrologue then
  begin
    oldprocessname := copy(mainform.ProcessLabel.Caption, pos(
      '-', mainform.ProcessLabel.Caption) + 1, length(mainform.ProcessLabel.Caption));
    oldprocess := processID;
    oldprocesshandle := processhandle;
    if (Sender is TMenuItemExtra) then
    begin
      pid := dword(ptrUint(TMenuItemExtra(Sender).Data));
      //the menuitem .data field contains the processid (and not some allocated memory)

      unpause;
      DetachIfPossible;

      with TProcessWindow.Create(self) do
      begin
        pwop(inttohex(pid, 8));
        ProcessLabel.Caption := TMenuItemExtra(Sender).Caption;
        Free;
      end;

      openprocessepilogue(oldprocessname, oldprocess, oldprocesshandle);

    end;
  end;
end;


{^^^^^^^^Processlist menuitem^^^^^^^^}
procedure TMainForm.miAboutClick(Sender: TObject);
begin
  About := TAbout.Create(self);
  About.showmodal;
end;

procedure TMainForm.CreateProcess1Click(Sender: TObject);
var
  x: dword;
  oldprocess: Dword;
  oldprocesshandle: thandle;
  oldprocessname: string;
begin
  if openprocessPrologue then
  begin

    oldprocessname := copy(mainform.ProcessLabel.Caption, pos(
      '-', mainform.ProcessLabel.Caption) + 1, length(mainform.ProcessLabel.Caption));
    oldprocess := processID;
    oldprocesshandle := processhandle;
    with TProcessWindow.Create(self) do
    begin
      miCreateProcess.Click;
      Free;
    end;

    if processid <> oldprocess then
      openprocessepilogue(oldprocessname, oldprocess, oldprocesshandle);

  end;
end;

procedure TMainForm.Helpindex1Click(Sender: TObject);
begin
  ShellExecute(0,'open','https://wiki.cheatengine.org/index.php',nil,nil,SW_SHOW);
//  Application.HelpContext(1);
end;

procedure TMainForm.New1Click(Sender: TObject);
begin
  if MessageDlg(rsAreYouSureYouWantToEraseTheDataInTheCurrentTable,
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    clearlist;
end;

procedure TMainForm.ClearList;
{
Will remove all entries from the cheattable, comments, and advanced options window
}
begin
  Comments.Memo1.Clear;
  comments.Memo1.Lines.Add(strInfoAboutTable);
  advancedoptions.codelist2.items.Clear;
  advancedoptions.numberofcodes := 0;

  addresslist.Clear;
end;

procedure TMainForm.File1Click(Sender: TObject);
begin

  miSaveScanresults.Enabled := memscan.nextscanCount > 0;
end;

procedure TMainForm.actOpenProcesslistExecute(Sender: TObject);
begin
  sbOpenProcess.Click;
end;

procedure TMainForm.Type1Click(Sender: TObject);
begin
  addresslist.doTypeChange;
end;

procedure TMainForm.DoGroupconfigButtonClick(sender: tobject);
var gcf: TfrmGroupScanAlgoritmGenerator;
begin
  gcf:=TfrmGroupScanAlgoritmGenerator.create(self);
  gcf.parseParameters(scanvalue.text);

  if gcf.showmodal=mrok then
    scanvalue.text:=gcf.getparameters;

  gcf.free;
end;


function TMainForm.GetScanType2: TScanOption;
{
not needed anymore
}
begin
  result:=GetScanType;
end;

function TMainForm.GetScanType: TScanOption;
begin
  result:=soExactValue;
  begin
    if not (getvartype in [vtBinary,vtString,vtByteArray]) then //not binary, string or bytearray
    begin
      if not btnNextScan.enabled then
      begin
        //first scan
        case scantype.ItemIndex of
          0: result:=soExactValue;
          1: result:=soBiggerThan;
          2: result:=soSmallerThan;
          3: result:=soValueBetween;
          4: result:=soUnknownValue;
        end;
      end
      else
      begin
        //next scan
        case scantype.itemindex of
          0: result:=soExactValue;
          1: result:=soBiggerThan;
          2: result:=soSmallerThan;
          3: result:=soValueBetween;
          4: result:=soIncreasedValue;
          5: result:=soIncreasedValueBy;
          6: result:=soDecreasedValue;
          7: result:=soDecreasedValueBy;
          8: result:=soChanged;
          9: result:=soUnchanged;
        end;
      end;
    end;
  end;
end;


function TMainForm.getVarType2: TVariableType; //obsolete
begin
  result:=getVarType;

end;

function TMainForm.getVarType: TVariableType;
begin
  case VarType.ItemIndex of
    0: result:=vtBinary; //binary
    1: result:=vtByte; //byte
    2: result:=vtWord; //2 bytes
    3: result:=vtDword; //4 bytes
    4: result:=vtQword; //8 bytes
    5: result:=vtSingle; //float
    6: result:=vtDouble; //double
    7: result:=vtString; //text
    8: result:=vtByteArray; //array of byte
    9: result:=vtAll; //all, only for new memscan
    10: result:=vtGrouped; //grouped, only for memscan
    else
      result:=vtCustom;
  end;
end;

procedure TMainForm.setVarType(vt: TVariableType);
begin
  if vartype.enabled then
  begin
    case vt of
      vtBinary: vartype.itemindex:=0;
      vtByte: vartype.itemindex:=1;
      vtWord: vartype.itemindex:=2;
      vtDword: vartype.itemindex:=3;
      vtQword: vartype.itemindex:=4;
      vtSingle: vartype.itemindex:=5;
      vtDouble: vartype.itemindex:=6;
      vtString: vartype.itemindex:=7;
      vtByteArray: vartype.itemindex:=8;
      vtAll: vartype.itemindex:=9;
      vtGrouped: vartype.itemindex:=10;
    end;

    vartype.OnChange(vartype);
  end;
end;

procedure TMainForm.MemscanGuiUpdate(sender: TObject; totaladdressestoscan: qword; currentlyscanned: qword; foundcount: qword);
begin
  self.foundcount:=foundcount;
end;

initialization
  DecimalSeparator := '.';
  ThousandSeparator := ',';

  {$i MainUnit.lrs}

end.

