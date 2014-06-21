unit TagEdtFrm;

{******************************************************************************}
{                                                                              }
{                StarUML - The Open Source UML/MDA Platform.                   }
{                                                                              }
{              Copyright (C) 2002-2005 - Plastic Software, Inc.                }
{                                                                              }
{                                                                              }
{ This program is free software; you can redistribute it and/or modify it      }
{ under the terms of the GNU General Public License as published by the Free   }
{ Software Foundation; either version 2 of the License, or (at your option)    }
{ any later version.                                                           }
{                                                                              }
{ This program is distributed in the hope that it will be useful, but WITHOUT  }
{ ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        }
{ FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for     }
{ more details.                                                                }
{                                                                              }
{ You should have received a copy of the GNU General Public License along with }
{ this program; if not, write to the Free Software Foundation, Inc., 51        }
{ Franklin St, Fifth Floor, Boston, MA 02110-1301 USA                          }
{                                                                              }
{ Linking StarUML statically or dynamically with other modules is making a     }
{ combined work based on StarUML. Thus, the terms and conditions of the GNU    }
{ General Public License cover the whole combination.                          }
{                                                                              }
{ In addition, as a special exception, Plastic Software give you permission to }
{ combine StarUML program with free software programs or libraries that are    }
{ released under the GNU LGPL/Mozilla/Apache/BSD and with code included in the }
{ standard release of ExpressBar, ExpressNavBar, ExpressInspector,             }
{ ExpressPageControl, ProGrammar, NextGrid under the commercial license (or    }
{ modified versions of such code, with unchanged license). You may copy and    }
{ distribute such a system following the terms of the GNU GPL for StarUML and  }
{ the licenses of the other code concerned, provided that you include the      }
{ source code of that other code when and as the GNU GPL requires distribution }
{ of source code. Plastic Software also give you permission to combine StarUML }
{ program with dynamically linking plug-in (or add-in) programs that are       }
{ released under the GPL-incompatible and proprietary license.                 }
{                                                                              }
{ Note that people who make modified versions of StarUML are not obligated to  }
{ grant this special exception for their modified versions; it is their choice }
{ whether to do so. The GNU General Public License gives permission to release }
{ a modified version without this exception; this exception also makes it      }
{ possible to release a modified version which carries forward this exception. }
{******************************************************************************}

interface

uses
  ExtCore, UMLModels, TagColEdtFrm,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, dxExEdtr, StdCtrls, dxCntner, dxInspct, dxInspRw, ExtCtrls, ComCtrls,
  ImgList;

type
  // Events
  PDataTaggedValueChangeEvent = procedure(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
    ATagDefinitionSetName: string; AName: string; Value: string) of object;
  PReferenceTaggedValueChangeEvent = procedure(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
    ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel) of object;
  PTaggedValueEvent = procedure(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
    ATagDefinitionSetName: string; AName: string) of object;

  PTagDefinitionSetInspector = class
  private
    Inspector: TdxInspector;
    TextMemo: TMemo;
    FOwner: TComponent;
    FModel: PExtensibleModel;
    FTagDefinitionSet: PTagDefinitionSet;
    FReadOnly: Boolean;
    FOnInspectorChange: TNotifyEvent;
    FOnDataTaggedValueChange: PDataTaggedValueChangeEvent;
    FOnReferenceTaggedValueChange: PReferenceTaggedValueChangeEvent;
    FOnAddCollectionTaggedValue: PCollectionTaggedValueEvent;
    FOnRemoveCollectionTaggedValue: PCollectionTaggedValueEvent;
    FOnChangeCollectionTaggedValueOrder: PChangeCollectionTaggedValueOrderEvent;
    FOnSetTaggedValueAsDefault: PTaggedValueEvent;
  private
    procedure SetReadOnly(Value: Boolean);
    function GetProfile: PProfile;
    function GetTagDefinition(Row: TdxInspectorRow): PTagDefinition;
    function GetFocusedTagDefinition: PTagDefinition;
    procedure ClearRows;
    procedure SetupRows;
    procedure SetTextPopupRowText(Row: TdxInspectorTextPopupRow);
    function IsDefaultValue(ATagDefinition: PTagDefinition): Boolean;

    procedure ChangeDataTaggedValue(Row: TdxInspectorRow; AsDefault: Boolean = False); overload;
    procedure ChangeDataTaggedValue(Row: TdxInspectorRow; Value: string; AsDefault: Boolean = False); overload;
    procedure ChangeReferenceTaggedValue(Row: TdxInspectorRow; Value: PExtensibleModel; AsDefault: Boolean = False);
    procedure SetTaggedValueAsDefault(Row: TdxInspectorRow);

    // event handlers
    procedure HandleAddCollectionTaggedValue(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
      ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel);
    procedure HandleRemoveCollectionTaggedValue(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
      ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel);
    procedure HandleChangeCollectionTaggedValueIndex(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
      ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel; NewIdx: Integer);

    procedure PickRowCloseUp(Sender: TObject; var Value: Variant; var Accept: Boolean);
    procedure CheckRowToggleClick(Sender: TObject; const Text: string; State: TdxCheckBoxState);
    procedure ButtonRowButtonClick(Sender: TObject; AbsoluteIndex: Integer);
    procedure PopupRowPopup(Sender: TObject; const EditText: string);
    procedure PopupRowCloseup(Sender: TObject; var Text: string; var Accept: Boolean);
    procedure InspectorEdited(Sender: TObject; Node: TdxInspectorNode; Row: TdxInspectorRow);
    procedure InspectorChangeNode(Sender: TObject; OldNode, Node: TdxInspectorNode);
    procedure InspectorDrawCaption(Sender: TdxInspectorRow;
      ACanvas: TCanvas; ARect: TRect; var AText: String; AFont: TFont;
      var AColor: TColor; var ADone: Boolean);
    procedure InspectorDrawValue(Sender: TdxInspectorRow; ACanvas: TCanvas;
      ARect: TRect; var AText: String; AFont: TFont; var AColor: TColor;
      var ADone: Boolean);
  public
    constructor Create(AOwner: TComponent; AInspector: TdxInspector);
    destructor Destory;
    procedure UpdateTaggedValues;
    procedure Setup;
    procedure SetFocusedTaggedValueAsDefault;
    property Model: PExtensibleModel read FModel write FModel;
    property TagDefinitionSet: PTagDefinitionSet read FTagDefinitionSet write FTagDefinitionSet;
    property Profile: PProfile read GetProfile;
    property FocusedTagDefinition: PTagDefinition read GetFocusedTagDefinition;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property OnDataTaggedValueChange: PDataTaggedValueChangeEvent read FOnDataTaggedValueChange write FOnDataTaggedValueChange;
    property OnReferenceTaggedValueChange: PReferenceTaggedValueChangeEvent read FOnReferenceTaggedValueChange write FOnReferenceTaggedValueChange;
    property OnInspectorChange: TNotifyEvent read FOnInspectorChange write FOnInspectorChange;
    property OnAddCollectionTaggedValue: PCollectionTaggedValueEvent
      read FOnAddCollectionTaggedValue write FOnAddCollectionTaggedValue;
    property OnRemoveCollectionTaggedValue: PCollectionTaggedValueEvent
      read FOnRemoveCollectionTaggedValue write FOnRemoveCollectionTaggedValue;
    property OnChangeCollectionTaggedValueOrder: PChangeCollectionTaggedValueOrderEvent
      read FOnChangeCollectionTaggedValueOrder write FOnChangeCollectionTaggedValueOrder;
    property OnSetTaggedValueAsDefault: PTaggedValueEvent read FOnSetTaggedValueAsDefault write FOnSetTaggedValueAsDefault;
  end;

  // TTaggedValueEditorForm
  TTaggedValueEditorForm = class(TForm)
    CloseButton: TButton;
    TaggedValueTabControl: TTabControl;
    TagDefinitionSetLabel: TLabel;
    TagDefinitionSetComboBox: TComboBox;
    TaggedValueLabel: TLabel;
    Inspector: TdxInspector;
    DefaultButton: TButton;
    RowImageList: TImageList;
    HelpButton: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TaggedValueTabControlChange(Sender: TObject);
    procedure TagDefinitionSetComboBoxSelect(Sender: TObject);
    procedure DefaultButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
  private
    TagDefinitionSetInspector: PTagDefinitionSetInspector;
    FModel: PExtensibleModel;
    FReadOnly: Boolean;
    FOnDataTaggedValueChange: PDataTaggedValueChangeEvent;
    FOnReferenceTaggedValueChange: PReferenceTaggedValueChangeEvent;
    FOnAddCollectionTaggedValue: PCollectionTaggedValueEvent;
    FOnRemoveCollectionTaggedValue: PCollectionTaggedValueEvent;
    FOnChangeCollectionTaggedValueOrder: PChangeCollectionTaggedValueOrderEvent;
    FOnSetTaggedValueAsDefault: PTaggedValueEvent;
    procedure SetModel(Value: PExtensibleModel);
    procedure SetReadOnly(Value: Boolean);
    function CurrentProfile: PProfile;
    function CurrentTagDefinitionSet: PTagDefinitionSet;
    procedure SetupTaggedValueTab(AProfile: PProfile; DefaultTagDefinitionSetName: string = '');
    procedure SetupTaggedTabControl;
    procedure UpdateFormTitle;
    procedure UpdateUIState;
    // event handlers
    procedure HandleDataTaggedValueChange(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
      ATagDefinitionSetName: string; AName: string; Value: string);
    procedure HandleReferenceTaggedValueChange(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
      ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel);
    procedure HandleInspectorChange(Sender: TObject);
    procedure HandleAddCollectionTaggedValue(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
      ATagDefintionSetName: string; AName: string; Value: PExtensibleModel);
    procedure HandleRemoveCollectionTaggedValue(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
      ATagDefintionSetName: string; AName: string; Value: PExtensibleModel);
    procedure HandleChangeCollectionTaggedValueIndex(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
      ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel; NewIdx: Integer);
    procedure HandleSetTaggedValueAsDefault(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
      ATagDefinitionSetName: string; AName: string);
  public
    procedure UpdateTaggedValues;
    procedure Inspect;
    procedure ShowTaggedValues(AModel: PExtensibleModel);
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property Model: PExtensibleModel read FModel write SetModel;
    property OnDataTaggedValueChange: PDataTaggedValueChangeEvent read FOnDataTaggedValueChange write FOnDataTaggedValueChange;
    property OnReferenceTaggedValueChange: PReferenceTaggedValueChangeEvent read FOnReferenceTaggedValueChange write FOnReferenceTaggedValueChange;
    property OnAddCollectionTaggedValue: PCollectionTaggedValueEvent
      read FOnAddCollectionTaggedValue write FOnAddCollectionTaggedValue;
    property OnRemoveCollectionTaggedValue: PCollectionTaggedValueEvent
      read FOnRemoveCollectionTaggedValue write FOnRemoveCollectionTaggedValue;
    property OnChangeCollectionTaggedValueOrder: PChangeCollectionTaggedValueOrderEvent
      read FOnChangeCollectionTaggedValueOrder write FOnChangeCollectionTaggedValueOrder;
    property OnSetTaggedValueAsDefault: PTaggedValueEvent read FOnSetTaggedValueAsDefault write FOnSetTaggedValueAsDefault;
  end;


var
  TaggedValueEditorForm: TTaggedValueEditorForm;

implementation

uses
  ElemLstFrm, NLS, NLS_StarUML,
  HtmlHlp;

{$R *.dfm}

const
  TAGGEDVALUEEDITORFORM_NOMODEL = 'Nothing Selected';
  CATEGORY_LEVEL = 0;
  TAGGEDVALUEITEM_LEVEL = 1;

////////////////////////////////////////////////////////////////////////////////
// PTagDefinitionSetInspector

constructor PTagDefinitionSetInspector.Create(AOwner: TComponent; AInspector: TdxInspector);
begin
  FOwner := AOwner;
  Inspector := AInspector;
  TextMemo := TMemo.Create(FOwner);
  TextMemo.WantReturns := True;
  TextMemo.WantTabs := True;
  Inspector.OnEdited := InspectorEdited;
  Inspector.OnChangeNode := InspectorChangeNode;
  Inspector.OnDrawCaption := InspectorDrawCaption;
  Inspector.OnDrawValue := InspectorDrawValue;
  TaggedValueCollectionEditorForm.OnAddCollectionTaggedValue := HandleAddCollectionTaggedValue;
  TaggedValueCollectionEditorForm.OnRemoveCollectionTaggedValue := HandleRemoveCollectionTaggedValue;
  TaggedValueCollectionEditorForm.OnChangeCollectionTaggedValueOrder := HandleChangeCollectionTaggedValueIndex;
end;

destructor PTagDefinitionSetInspector.Destory;
begin
  TextMemo.Free;
  inherited;
end;

procedure PTagDefinitionSetInspector.SetReadOnly(Value: Boolean);
begin
  FReadOnly := Value;
  TaggedValueCollectionEditorForm.ReadOnly := FReadOnly;
end;

function PTagDefinitionSetInspector.GetProfile: PProfile;
begin
  if FTagDefinitionSet = nil then
    Result := nil
  else
    Result := FTagDefinitionSet.Profile;
end;

function PTagDefinitionSetInspector.GetTagDefinition(Row: TdxInspectorRow): PTagDefinition;
var
  ParentRow: TdxInspectorRow;
begin
  Result := nil;
  if FModel = nil then Exit;
  if Row.Node.Level = TAGGEDVALUEITEM_LEVEL then begin
    ParentRow := (Row.Node.Parent as TdxInspectorRowNode).Row;
    Result := ExtensionManager.FindTagDefinition(GetProfile.Name, ParentRow.Caption, Row.Caption);
  end;
end;

function PTagDefinitionSetInspector.GetFocusedTagDefinition: PTagDefinition;
begin
  Result := nil;
  if (Inspector.FocusedNode <> nil) then
    Result := GetTagDefinition((Inspector.FocusedNode as TdxInspectorRowNode).Row);
end;

function PTagDefinitionSetInspector.IsDefaultValue(ATagDefinition: PTagDefinition): Boolean;
begin
  Result := (FModel.FindTaggedValue(Profile.Name, ATagDefinition.TagDefinitionSet.Name, ATagDefinition.Name) = nil);
end;

procedure PTagDefinitionSetInspector.ClearRows;
begin
  Inspector.ClearRows;
end;

procedure PTagDefinitionSetInspector.SetupRows;

  function GetParentTagDefinitionSet(TS: PTagDefinitionSet): PTagDefinitionSet;
  begin
    Result := nil;
    if (TS.Stereotype <> nil) and (TS.Stereotype.Parent <> nil) and
      (TS.Stereotype.Parent.TagDefinitionSet <> nil) then
      Result := TS.Stereotype.Parent.TagDefinitionSet;
  end;

  procedure SetupTagDefintionSetCategory(ATagDefinitionSet: PTagDefinitionSet);
  var
    TD: PTagDefinition;
    C: TdxInspectorRowNode;
    N: TdxInspectorRowNode;
    I, J: Integer;
  begin
    C := Inspector.AddEx(TdxInspectorTextRow);
    C.Row.IsCategory := True;
    C.Row.Caption := ATagDefinitionSet.Name;
    for I := 0 to ATagDefinitionSet.TagDefinitionCount - 1 do begin
      TD := ATagDefinitionSet.TagDefinitions[I];
      case TD.TagType of
        tkInteger, tkReal:
          begin
            N := C.AddChildEx(TdxInspectorTextRow);
            (N.Row as TdxInspectorTextRow).Text := TD.DefaultValue;
            N.Row.ReadOnly := TD.Lock or FReadOnly;
            N.Row.ImageIndex := 0;
          end;
        tkBoolean:
          begin
            N := C.AddChildEx(TdxInspectorTextCheckRow);
            (N.Row as TdxInspectorTextCheckRow).Text := TD.DefaultValue;
            if not (TD.Lock or FReadOnly) then
              (N.Row as TdxInspectorTextCheckRow).OnToggleClick := CheckRowToggleClick;
            N.Row.ReadOnly := TD.Lock or FReadOnly;
            N.Row.ImageIndex := 0;
          end;
        tkString:
          begin
            N := C.AddChildEx(TdxInspectorTextPopupRow);
            with (N.Row as TdxInspectorTextPopupRow) do begin
              Text := TD.DefaultValue;
              PopupControl := TextMemo;
              PopupFormBorderStyle := pbsDialog;
              PopupAutoSize := False;
              OnPopup := PopupRowPopup;
              if not (TD.Lock or FReadOnly) then
                OnCloseUp := PopupRowCloseUp;
              ReadOnly := TD.Lock or FReadOnly;
              ImageIndex := 0;
            end;
            TextMemo.ReadOnly := TD.Lock or FReadOnly;
          end;
        tkEnumeration:
          begin
            N := C.AddChildEx(TdxInspectorTextPickRow);
            with N.Row as TdxInspectorTextPickRow do begin
              for J := 0 to TD.LiteralCount - 1 do
                Items.Add(TD.Literals[J]);
              Text := TD.DefaultValue;
              DropDownListStyle := True;
              ReadOnly := True;
              if not (TD.Lock or FReadOnly) then
                OnCloseUp := PickRowCloseUp;
              ImageIndex := 2;
            end;
          end;
        tkReference:
          begin
            N := C.AddChildEx(TdxInspectorTextButtonRow);
            N.Row.ReadOnly := True;
            N.Row.ImageIndex := 0;
            if not (TD.Lock or FReadOnly) then
              (N.Row as TdxInspectorTextButtonRow).OnButtonClick := ButtonRowButtonClick;
          end;
        tkCollection:
          begin
            N := C.AddChildEx(TdxInspectorTextButtonRow);
            N.Row.ReadOnly := True;
            N.Row.ImageIndex := 3;
            (N.Row as TdxInspectorTextButtonRow).OnButtonClick := ButtonRowButtonClick;
          end;
      end;
      N.Row.Caption := TD.Name;
      N.Row.Hint := TagTypeToStr(TD.TagType);
      if TD.Lock then
        N.Row.ImageIndex := 1;
    end;
    C.Expand(True);
    if GetParentTagDefinitionSet(ATagDefinitionSet) <> nil then
      SetupTagDefintionSetCategory(GetParentTagDefinitionSet(ATagDefinitionSet));
  end;

begin
  Inspector.BeginUpdate;
  ClearRows;
  if (FModel <> nil) and (FTagDefinitionSet <> nil) then
    SetupTagDefintionSetCategory(FTagDefinitionSet);
  Inspector.EndUpdate;
end;

procedure PTagDefinitionSetInspector.SetTextPopupRowText(Row: TdxInspectorTextPopupRow);
var
  T: PTagDefinition;
  V: string;
begin
  if Row <> nil then begin
    T := GetTagDefinition(Row);
    V := FModel.QueryDataTaggedValue(Profile.Name, T.TagDefinitionSet.Name, T.Name);
    if Pos(#10, V) > 0 then begin
      Row.Text := TXT_TAGGEDVALUE_TEXT;
      Row.ReadOnly := True;
    end
    else begin
      Row.Text := V;
      Row.ReadOnly := T.Lock or FReadOnly;
    end;
  end;
end;

procedure PTagDefinitionSetInspector.ChangeDataTaggedValue(Row: TdxInspectorRow; AsDefault: Boolean = False);
var
  T: PTagDefinition;
  Value: string;
begin
  T := GetTagDefinition(Row);
  case T.TagType of
    tkInteger, tkReal:
      Value := (Row as TdxInspectorTextRow).Text;
    tkBoolean:
      Value := (Row as TdxInspectorTextCheckRow).Text;
    tkString:
      Value := (Row as TdxInspectorTextPopupRow).Text;
    tkEnumeration:
      Value := (Row as TdxInspectorTextPickRow).Text;
  end;
  if Assigned(FOnDataTaggedValueChange) then
    FOnDataTaggedValueChange(Self, FModel, Profile.Name, T.TagDefinitionSet.Name, T.Name, Value);
end;

procedure PTagDefinitionSetInspector.ChangeDataTaggedValue(Row: TdxInspectorRow; Value: string; AsDefault: Boolean = False);
var
  T: PTagDefinition;
begin
  T := GetTagDefinition(Row);
  if IsDataTagType(T.TagType) and Assigned(FOnDataTaggedValueChange) then
    FOnDataTaggedValueChange(Self, FModel, Profile.Name, T.TagDefinitionSet.Name, T.Name, Value);
end;

procedure PTagDefinitionSetInspector.ChangeReferenceTaggedValue(Row: TdxInspectorRow; Value: PExtensibleModel; AsDefault: Boolean = False);
var
  T: PTagDefinition;
begin
  T := GetTagDefinition(Row);
  if (T.TagType = tkReference) and Assigned(FOnReferenceTaggedValueChange) then
    FOnReferenceTaggedValueChange(Self, FModel, Profile.Name, T.TagDefinitionSet.Name, T.Name, Value);
end;

procedure PTagDefinitionSetInspector.SetTaggedValueAsDefault(Row: TdxInspectorRow);
var
  T: PTagDefinition;
begin
  T := GetTagDefinition(Row);
  if (T <> nil) and Assigned(FOnSetTaggedValueAsDefault) then
    FOnSetTaggedValueAsDefault(Self,FModel, Profile.Name, T.TagDefinitionSet.Name, T.Name);
end;

procedure PTagDefinitionSetInspector.HandleAddCollectionTaggedValue(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
  ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel);
begin
  if Assigned(FOnAddCollectionTaggedValue) then
    FOnAddCollectionTaggedValue(Self, AModel, AProfileName, ATagDefinitionSetName, AName, Value);
end;

procedure PTagDefinitionSetInspector.HandleRemoveCollectionTaggedValue(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
  ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel);
begin
  if Assigned(FOnRemoveCollectionTaggedValue) then
    FOnRemoveCollectionTaggedValue(Self, AModel, AProfileName, ATagDefinitionSetName, AName, Value);
end;

procedure PTagDefinitionSetInspector.HandleChangeCollectionTaggedValueIndex(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
  ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel; NewIdx: Integer);
begin
  if Assigned(FOnChangeCollectionTaggedValueOrder) then
    FOnChangeCollectionTaggedValueOrder(Self, AModel, AProfileName, ATagDefinitionSetName, AName, Value, NewIdx);
end;

procedure PTagDefinitionSetInspector.InspectorEdited(Sender: TObject; Node: TdxInspectorNode; Row: TdxInspectorRow);
begin
  ChangeDataTaggedValue(Row);
end;

procedure PTagDefinitionSetInspector.PickRowCloseUp(Sender: TObject; var Value: Variant; var Accept: Boolean);
begin
  if (Sender as TdxInspectorTextPickRow).Text <> Value then begin
    (Sender as TdxInspectorTextPickRow).Text := Value;
    ChangeDataTaggedValue(Sender as TdxInspectorRow);
  end;
end;

procedure PTagDefinitionSetInspector.CheckRowToggleClick(Sender: TObject; const Text: string; State: TdxCheckBoxState);
begin
  (Sender as TdxInspectorTextCheckRow).Text := Text;
  ChangeDataTaggedValue(Sender as TdxInspectorRow);
end;

procedure PTagDefinitionSetInspector.ButtonRowButtonClick(Sender: TObject; AbsoluteIndex: Integer);
var
  T: PTagDefinition;
begin
  T := GetTagDefinition(Sender as TdxInspectorRow);
  case T.TagType of
    tkReference:
      begin
        ElementListForm.ClearListElements;
        if T.ReferenceType = '' then
          ElementListForm.AddListElementsByClass(DEFAULT_REFERENCETYPE, True)
        else
          ElementListForm.AddListElementsByClass(T.ReferenceType, True);
        ElementListForm.AllowNull := True;
        if ElementListForm.Execute(TXT_TAGGED_VALUE) then begin
          ChangeReferenceTaggedValue(Sender as TdxInspectorRow, ElementListForm.SelectedModel as PExtensibleModel);
        end;
      end;
    tkCollection:
      TaggedValueCollectionEditorForm.ShowTaggedValueCollection(FModel, GetTagDefinition(Sender as TdxInspectorRow));
  end;
end;

procedure PTagDefinitionSetInspector.PopupRowPopup(Sender: TObject; const EditText: string);
var
  T: PTagDefinition;
begin
  T := GetTagDefinition(Sender as TdxInspectorRow);
  TextMemo.Lines.Text := FModel.QueryDataTaggedValue(Profile.Name, T.TagDefinitionSet.Name, T.Name);
  SetWindowPos((Inspector.InplaceEditor as TdxInspectorPopupEdit).PopupForm.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or
     SWP_NOSIZE or SWP_NOACTIVATE);
end;

procedure PTagDefinitionSetInspector.PopupRowCloseup(Sender: TObject; var Text: string; var Accept: Boolean);
begin
  if (Sender as TdxInspectorTextPopupRow).Text <> TextMemo.Text then
    ChangeDataTaggedValue(Sender as TdxInspectorRow, TextMemo.Text);
  Inspector.SetFocus;
end;

procedure PTagDefinitionSetInspector.InspectorChangeNode(Sender: TObject; OldNode, Node: TdxInspectorNode);
begin
  if Assigned(FOnInspectorChange) then
    FOnInspectorChange(Self);
end;

procedure PTagDefinitionSetInspector.InspectorDrawCaption(
  Sender: TdxInspectorRow; ACanvas: TCanvas; ARect: TRect;
  var AText: String; AFont: TFont; var AColor: TColor; var ADone: Boolean);
var
  T: PTagDefinition;
begin
  if Sender.IsCategory then Exit;
  T := GetTagDefinition(Sender);
  if Sender.Node.Focused then begin
    if IsDefaultValue(T) then
      AFont.Color := clGrayText
    else
      AFont.Color := clHighlightText;
  end
  else begin
    if IsDefaultValue(T) then
      AFont.Color := clGrayText
    else
      AFont.Color := clWindowText;
  end;
end;

procedure PTagDefinitionSetInspector.InspectorDrawValue(
  Sender: TdxInspectorRow; ACanvas: TCanvas; ARect: TRect;
  var AText: String; AFont: TFont; var AColor: TColor; var ADone: Boolean);
var
  T: PTagDefinition;
  V: string;
begin
  if Sender.IsCategory then Exit;
  T := GetTagDefinition(Sender);
  if Sender.Node.Focused and Inspector.Focused then begin
    if IsDefaultValue(T) then
      AFont.Color := clGrayText
    else
      AFont.Color := clHighlightText;
  end
  else begin
    if IsDefaultValue(T) then
      AFont.Color := clGrayText
    else
      AFont.Color := clWindowText;
  end;
  if Sender is TdxInspectorTextPopupRow then begin
    V := FModel.QueryDataTaggedValue(Profile.Name, T.TagDefinitionSet.Name, T.Name);
    if Pos(#10, V) > 0 then
      AText := TXT_TAGGEDVALUE_TEXT
    else
      AText := V;
  end;
end;

procedure PTagDefinitionSetInspector.UpdateTaggedValues;
var
  T: PTagDefinition;
  TV: PTaggedValue;
  CateRow, Row: TdxInspectorRow;
  I, J: Integer;
begin
  if FModel <> nil then
  begin
    for I := 0 to Inspector.Count - 1 do begin
      CateRow := (Inspector.Items[I] as TdxInspectorRowNode).Row;
      for J := 0 to CateRow.Node.Count - 1 do begin
        Row := (CateRow.Node.Items[J] as TdxInspectorRowNode).Row;
        // Assertion
        Assert(not Row.IsCategory);
        // Assertion
        T := GetTagDefinition(Row);
        TV := FModel.FindTaggedValue(Profile.Name, T.TagDefinitionSet.Name, T.Name);
        case T.TagType of
          tkInteger, tkReal:
            (Row as TdxInspectorTextRow).Text := FModel.QueryDataTaggedValue(Profile.Name, T.TagDefinitionSet.Name, T.Name);
          tkBoolean:
            (Row as TdxInspectorTextCheckRow).Text := FModel.QueryDataTaggedValue(Profile.Name, T.TagDefinitionSet.Name, T.Name);
          tkEnumeration:
            (Row as TdxInspectorTextPickRow).Text := FModel.QueryDataTaggedValue(Profile.Name, T.TagDefinitionSet.Name, T.Name);
          tkString:
            SetTextPopupRowText(Row as TdxInspectorTextPopupRow);
          tkReference:
            if (TV <> nil) and (TV.ReferenceValueCount > 0) then
              (Row as TdxInspectorTextButtonRow).Text := TV.ReferenceValues[0].Name
            else
              (Row as TdxInspectorTextButtonRow).Text := '';
          tkCollection:
            (Row as TdxInspectorTextButtonRow).Text := TXT_TAGGEDVALUE_COLLECTION;
        end;
      end;
    end;
    if Assigned(FOnInspectorChange) then
      FOnInspectorChange(Self);
  end;
  if FModel <> nil then
    ReadOnly := Model.ReadOnly
  else
    ReadOnly := True;
end;

procedure PTagDefinitionSetInspector.Setup;
begin
  SetupRows;
end;

procedure PTagDefinitionSetInspector.SetFocusedTaggedValueAsDefault;
begin
  SetTaggedValueAsDefault((Inspector.FocusedNode as TdxInspectorRowNode).Row);
end;

// PTagDefinitionSetInspector
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TTaggedValueEditorForm

procedure TTaggedValueEditorForm.FormCreate(Sender: TObject);
begin
  TagDefinitionSetInspector := PTagDefinitionSetInspector.Create(Self, Inspector);
  TagDefinitionSetInspector.OnInspectorChange := HandleInspectorChange;
  TagDefinitionSetInspector.OnDataTaggedValueChange := HandleDataTaggedValueChange;
  TagDefinitionSetInspector.OnReferenceTaggedValueChange := HandleReferenceTaggedValueChange;
  TagDefinitionSetInspector.OnAddCollectionTaggedValue := HandleAddCollectionTaggedValue;
  TagDefinitionSetInspector.OnRemoveCollectionTaggedValue := HandleRemoveCollectionTaggedValue;
  TagDefinitionSetInspector.OnChangeCollectionTaggedValueOrder := HandleChangeCollectionTaggedValueIndex;
  TagDefinitionSetInspector.OnSetTaggedValueAsDefault := HandleSetTaggedValueAsDefault;
  NLSManager.SetFile(ExtractFilePath(Application.ExeName) + 'NLS\TAGVALED.LNG');
  NLSManager.TranslateComponent(Self, []);
end;

procedure TTaggedValueEditorForm.FormDestroy(Sender: TObject);
begin
  TagDefinitionSetInspector.Free;
end;

procedure TTaggedValueEditorForm.SetModel(Value: PExtensibleModel);
begin
  FModel := Value;
  TagDefinitionSetInspector.Model := Value;
end;

procedure TTaggedValueEditorForm.SetReadOnly(Value: Boolean);
begin
  FReadOnly := Value;
  TagDefinitionSetInspector.ReadOnly := Value;
end;

function TTaggedValueEditorForm.CurrentProfile: PProfile;
begin
  Result := nil;
  if TaggedValueTabControl.TabIndex <> -1 then
    Result := TaggedValueTabControl.Tabs.Objects[TaggedValueTabControl.TabIndex] as PProfile;
end;

function TTaggedValueEditorForm.CurrentTagDefinitionSet: PTagDefinitionSet;
begin
  Result := nil;
  if TagDefinitionSetComboBox.ItemIndex <> -1 then
    Result := TagDefinitionSetComboBox.Items.Objects[TagDefinitionSetComboBox.ItemIndex] as PTagDefinitionSet;
end;

procedure TTaggedValueEditorForm.SetupTaggedValueTab(AProfile: PProfile; DefaultTagDefinitionSetName: string = '');
var
  Idx: Integer;
  I: Integer;
begin
  TagDefinitionSetComboBox.Clear;
  for I := 0 to AProfile.TagDefinitionSetCount - 1 do
    if AProfile.TagDefinitionSets[I].CanApplyTo(FModel.MetaClass.Name) then
      TagDefinitionSetComboBox.Items.AddObject(AProfile.TagDefinitionSets[I].Name,
        AProfile.TagDefinitionSets[I]);
  if TagDefinitionSetComboBox.Items.Count > 0 then begin
    Idx := TagDefinitionSetComboBox.Items.IndexOf(DefaultTagDefinitionSetName);
    if (DefaultTagDefinitionSetName <> '') and (Idx <> -1) then begin
      TagDefinitionSetComboBox.ItemIndex := Idx;
      TagDefinitionSetInspector.TagDefinitionSet := TagDefinitionSetComboBox.Items.Objects[Idx] as PTagDefinitionSet;
      TagDefinitionSetInspector.Setup;
    end
    else begin
      TagDefinitionSetComboBox.ItemIndex := 0;
      TagDefinitionSetInspector.TagDefinitionSet := TagDefinitionSetComboBox.Items.Objects[0] as PTagDefinitionSet;
      TagDefinitionSetInspector.Setup;
    end;
  end;
end;

procedure TTaggedValueEditorForm.SetupTaggedTabControl;

  function ExistsAvailableTagDefinitionSet(AProfile: PProfile): Boolean;
  var
    I: Integer;
  begin
    Result := False;
    for I := 0 to AProfile.TagDefinitionSetCount - 1 do
      if AProfile.TagDefinitionSets[I].CanApplyTo(FModel.MetaClass.Name) then begin
        Result := True;
        Exit;
      end;
  end;

var
  S: PStereotype;
  Idx: Integer;
  I: Integer;
begin
  TaggedValueTabControl.Tabs.Clear;
  TagDefinitionSetComboBox.Items.Clear;
  TagDefinitionSetInspector.ClearRows;

  if FModel <> nil then begin
    // append tab sheets for include profiles
    for I := 0 to ExtensionManager.IncludedProfileCount - 1 do begin
      if ExistsAvailableTagDefinitionSet(ExtensionManager.IncludedProfiles[I]) then
        TaggedValueTabControl.Tabs.AddObject(ExtensionManager.IncludedProfiles[I].Name,
          ExtensionManager.IncludedProfiles[I]);
    end;
    // set active tab sheet
    if (TaggedValueTabControl.Tabs.Count > 0){ and (FModel.StereotypeProfile <> '') }then begin
      Idx := TaggedValueTabControl.Tabs.IndexOf(FModel.StereotypeProfile);
      S := ExtensionManager.FindStereotype(FModel.StereotypeProfile, FModel.StereotypeName, FModel.MetaClass.Name);
      if (Idx <> -1) and (S <> nil) and (S.TagDefinitionSet <> nil) then begin
        TaggedValueTabControl.TabIndex := Idx;
        SetupTaggedValueTab(TaggedValueTabControl.Tabs.Objects[Idx] as PProfile, S.TagDefinitionSet.Name);
      end
      else begin
        TaggedValueTabControl.TabIndex := 0;
        SetupTaggedValueTab(TaggedValueTabControl.Tabs.Objects[0] as PProfile);
      end;
    end;
  end;
end;

procedure TTaggedValueEditorForm.UpdateFormTitle;
begin
  if FModel = nil then
    Caption := TXT_TITLE_TAGGEDVALUEEDITORFORM + ' - (' + TAGGEDVALUEEDITORFORM_NOMODEL + ')'
  else
    Caption := TXT_TITLE_TAGGEDVALUEEDITORFORM + ' - ('
      + Copy(FModel.ClassName, 2, Length(FModel.ClassName) - 1) + ') ' + FModel.Name;
end;

procedure TTaggedValueEditorForm.UpdateUIState;
var
  FD: PTagDefinition;
begin
  FD := TagDefinitionSetInspector.FocusedTagDefinition;
  DefaultButton.Enabled := (FModel <> nil) and (not FReadOnly) and (FD <> nil)
    and (not FD.Lock) and (FModel.FindTaggedValue(CurrentProfile.Name, FD.TagDefinitionSet.Name, FD.Name) <> nil);
end;

procedure TTaggedValueEditorForm.HandleDataTaggedValueChange(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
  ATagDefinitionSetName: string; AName: string; Value: string);
begin
  if Assigned(FOnDataTaggedValueChange) then
    FOnDataTaggedValueChange(Self, AModel, AProfileName, ATagDefinitionSetName, AName, Value);
end;

procedure TTaggedValueEditorForm.HandleReferenceTaggedValueChange(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
  ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel);
begin
  if Assigned(FOnReferenceTaggedValueChange) then
    FOnReferenceTaggedValueChange(Self, AModel, AProfileName, ATagDefinitionSetName, AName, Value);
end;

procedure TTaggedValueEditorForm.HandleInspectorChange(Sender: TObject);
begin
  UpdateUIState;
end;

procedure TTaggedValueEditorForm.HandleAddCollectionTaggedValue(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
  ATagDefintionSetName: string; AName: string; Value: PExtensibleModel);
begin
  if Assigned(FOnAddCollectionTaggedValue) then
    FOnAddCollectionTaggedValue(Self, AModel, AProfileName, ATagDefintionSetName, AName, Value);
end;

procedure TTaggedValueEditorForm.HandleRemoveCollectionTaggedValue(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
  ATagDefintionSetName: string; AName: string; Value: PExtensibleModel);
begin
  if Assigned(FOnRemoveCollectionTaggedValue) then
    FOnRemoveCollectionTaggedValue(Self, AModel, AProfileName, ATagDefintionSetName, AName, Value);
end;

procedure TTaggedValueEditorForm.HandleChangeCollectionTaggedValueIndex(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
  ATagDefinitionSetName: string; AName: string; Value: PExtensibleModel; NewIdx: Integer);
begin
  if Assigned(FOnChangeCollectionTaggedValueOrder) then
    FOnChangeCollectionTaggedValueOrder(Self, AModel, AProfileName, ATagDefinitionSetName, AName, Value, NewIdx);
end;

procedure TTaggedValueEditorForm.HandleSetTaggedValueAsDefault(Sender: TObject; AModel: PExtensibleModel; AProfileName: string;
  ATagDefinitionSetName: string; AName: string);
begin
  if Assigned(FOnSetTaggedValueAsDefault) then
    FOnSetTaggedValueAsDefault(Self, AModel, AProfileName, ATagDefinitionSetName, AName);
end;

procedure TTaggedValueEditorForm.UpdateTaggedValues;
begin
  if not Visible then
    Exit;
  TagDefinitionSetInspector.UpdateTaggedValues;
  if TaggedValueCollectionEditorForm.Visible then
    TaggedValueCollectionEditorForm.UpdateTaggedValueCollection;
  UpdateFormTitle;
  UpdateUIState;
end;

procedure TTaggedValueEditorForm.Inspect;
begin
  if not Visible then
    Exit;
  SetupTaggedTabControl;
  UpdateTaggedValues;
end;

procedure TTaggedValueEditorForm.ShowTaggedValues(AModel: PExtensibleModel);
begin
  FModel := AModel;
  Show;
  Inspect;
end;

// event handlers
procedure TTaggedValueEditorForm.TaggedValueTabControlChange(Sender: TObject);
begin
  SetupTaggedValueTab(CurrentProfile);
  UpdateTaggedValues;
end;

procedure TTaggedValueEditorForm.TagDefinitionSetComboBoxSelect(Sender: TObject);
begin
  TagDefinitionSetInspector.TagDefinitionSet := CurrentTagDefinitionSet;
  TagDefinitionSetInspector.Setup;
  UpdateTaggedValues;
end;

procedure TTaggedValueEditorForm.DefaultButtonClick(Sender: TObject);
begin
  TagDefinitionSetInspector.SetFocusedTaggedValueAsDefault;
end;

procedure TTaggedValueEditorForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

// TTaggedValueEditorForm
////////////////////////////////////////////////////////////////////////////////

procedure TTaggedValueEditorForm.HelpButtonClick(Sender: TObject);
begin
  ShowStarUMLHelpPage;
end;

end.
