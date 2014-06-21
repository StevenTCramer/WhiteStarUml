unit PatternAddInFrm;

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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, TreeViewEx, JvWizard, dxExEdtr,
  dxCntner, dxInspct, dxInspRw, ImgList,
  StarUML_TLB, PatternDef, JvExControls, JvComponent;

type
   // Forward declaration
  PPatternItemRow = class;

  // Exception
  EInvalidParameterValue = class(Exception);

  // TPatternAddInForm
  TPatternAddInForm = class(TForm)
    PatternGenWizard: TJvWizard;
    SelectPatternPage: TJvWizardInteriorPage;
    DescriptionMemo: TMemo;
    PatternTreeView: TTreeView;
    PatternParameterPage: TJvWizardInteriorPage;
    PatternInspector: TdxInspector;
    CategoryImageList: TImageList;
    PatternResultPage: TJvWizardInteriorPage;
    BasePanel: TPanel;
    ResultInfoLabel: TLabel;
    DescriptionPanel: TPanel;
    PatternDescriptionLabel: TLabel;
    ParamDescLabel: TLabel;
    PatternMemoBasePanel: TPanel;
    ParameterDescriptionLabel: TLabel;
    PatternTreeLabel: TLabel;
    PatternHelpButton: TButton;
    TreeImage: TImageList;
    PatternNameLabel: TLabel;
    PatternMemo: TMemo;
    ResultInfoListView: TListView;
    PatternParamLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PatternTreeViewChange(Sender: TObject; Node: TTreeNode);
    procedure PatternParameterPageNextButtonClick(Sender: TObject; var Stop: Boolean);
    procedure PatternResultPageFinishButtonClick(Sender: TObject; var Stop: Boolean);
    procedure SelectPatternPageCancelButtonClick(Sender: TObject;
      var Stop: Boolean);
    procedure PatternTreeViewCollapsed(Sender: TObject; Node: TTreeNode);
    procedure PatternTreeViewExpanded(Sender: TObject; Node: TTreeNode);
    procedure PatternHelpButtonClick(Sender: TObject);
    procedure PatternInspectorChangeNode(Sender: TObject; OldNode, Node: TdxInspectorNode);
  private
    PatternRows: TList;
    FPattern: PatternDef.PPattern;
    procedure BuildPatternTreeView;
    procedure BuildPatternInspectorView(Inspector: TdxInspector; PPN: PPatternNode);
    procedure ClearPatternRows;
    procedure ApplyPattern;
    procedure ShowDescription(PID: PPattern);
    function FindPatternRow(Row: TdxInspectorRow): PPatternItemRow;
    function AssignInspectorRowValues: Boolean;
  public
    StarUMLApp: IStarUMLApplication;
    property PatternRef: PPattern read FPattern write FPattern;
  end;

  // PPatternItemRow
  PPatternItemRow = class
  protected
    FInspector: TdxInspector;
    FPatternParameter: PPatternParameter;
    FInspectorRow: TdxInspectorRow;
    FParentRow: TdxInspectorRow;
    procedure CreateInspectorRow; virtual; abstract;
    procedure DrawInspector; virtual; abstract;
    function FindExistElement(ElemName: string): IUMLElement;
  public
    constructor Create(AInspector: TdxInspector; APatternParameter: PPatternParameter;
      ParentRow: TdxInspectorRow);
    procedure AssignParameterValue; virtual;
    property InspectorRow: TdxInspectorRow read FInspectorRow;
  end;

    // PIntegerPatternItemRow
  PIntegerPatternItemRow = class(PPatternItemRow)
  protected
    procedure CreateInspectorRow; override;
    procedure DrawInspector; override;
  public
    procedure AssignParameterValue; override;
  end;

  // PBooleanPatternItemRow
  PBooleanPatternItemRow = class(PPatternItemRow)
  protected
    procedure CreateInspectorRow; override;
    procedure DrawInspector; override;
  public
    procedure AssignParameterValue; override;
  end;

  // PStringPatternItemRow
  PStringPatternItemRow = class(PPatternItemRow)
  protected
    procedure CreateInspectorRow; override;
    procedure DrawInspector; override;
  public
    procedure AssignParameterValue; override;
  end;

  // PEnumerationPatternItemRow
  PEnumerationPatternItemRow = class(PPatternItemRow)
  private
    procedure PickRowCloseUp(Sender: TObject; var Value: Variant; var Accept: Boolean);
  protected
    procedure CreateInspectorRow; override;
    procedure DrawInspector; override;
  public
    procedure AssignParameterValue; override;
  end;

  // PElementPatternItemRow
  PElementPatternItemRow = class(PPatternItemRow)
  private
  protected
    procedure CreateInspectorRow; override;
    procedure DrawInspector; override;
  public
    procedure HandleBtnClick(Sender: TObject; AbsoluteIndex: Integer);
    procedure AssignParameterValue; override;
  end;

  // PElementListPatternItemRow
  PElementListPatternItemRow = class(PPatternItemRow)
  protected
    procedure CreateInspectorRow; override;
    procedure DrawInspector; override;
  public
    procedure HandleBtnListClick(Sender: TObject; AbsoluteIndex: Integer);
    procedure AssignParameterValue; override;
  end;

var
  PatternAddInForm: TPatternAddInForm;

implementation

uses
  ShellAPI,
  Symbols, NLS, NLS_PatternAddIn, PatternParamColEditForm;

{$R *.dfm}

////////////////////////////////////////////////////////////////////////////////
// TPatternAddInForm

procedure TPatternAddInForm.BuildPatternTreeView;

  procedure BuildTreeNodeRecurse(ATreeNode: TTreeNode; APatternFolder: PPatternFolder);
  var
    I: Integer;
    TN, SubTN: TTreeNode;
    PN: PPatternNode;
  begin
    TN := PatternTreeView.Items.AddChild(ATreeNode, APatternFolder.Name);
    TN.Data := APatternFolder;
    TN.StateIndex := 3;
    for I := 0 to APatternFolder.PatternNodeCount - 1 do
    begin
      PN := APatternFolder.PatternNodes[I];
      if PN is PPatternFolder then
      begin
        BuildTreeNodeRecurse(TN, PN as PPatternFolder);
      end
      else begin
        SubTN := PatternTreeView.Items.AddChild(TN, PN.Name);
        SubTN.Data := PN;
        SubTN.StateIndex := 5;
      end;
    end;
  end;

begin
  PatternTreeView.Items.Clear;
  BuildTreeNodeRecurse(nil, PatternManager.PatternRepository);
end;

procedure TPatternAddInForm.BuildPatternInspectorView(Inspector: TdxInspector; PPN: PPatternNode);
var
  ParameterRow: TdxInspectorTextRow;
  PatternRef: PatternDef.PPattern;
  ParameterRef: PatternDef.PPatternParameter;
  PatternRow : PPatternItemRow;
  I: Integer;
begin
  ClearPatternRows;
  PatternRef := PPN as PPattern;
  ParameterRow := Inspector.AddEx(TdxInspectorTextRow).Row as TdxInspectorTextRow;
  ParameterRow.IsCategory := True;
  ParameterRow.Caption := PatternRef.Name;
  for I := 0 to PatternRef.PatternParameterCount - 1 do begin
    PatternRow := nil;
    ParameterRef := PatternRef.Parameters[I];
    case ParameterRef.ParamType of
      ptInteger:
        PatternRow := PIntegerPatternItemRow.Create(Inspector, ParameterRef, ParameterRow);
      ptBoolean:
        PatternRow := PBooleanPatternItemRow.Create(Inspector, ParameterRef, ParameterRow);
      ptString:
        PatternRow := PStringPatternItemRow.Create(Inspector, ParameterRef, ParameterRow);
      ptEnumeration:
        PatternRow := PEnumerationPatternItemRow.Create(Inspector, ParameterRef, ParameterRow);
      ptElement:
        PatternRow := PElementPatternItemRow.Create(Inspector, ParameterRef, ParameterRow);
      ptElementList:
        PatternRow := PElementListPatternItemRow.Create(Inspector, ParameterRef, ParameterRow);
    end;
    if PatternRow <> nil then PatternRows.Add(PatternRow);
  end;
  Inspector.FullExpand;
end;

procedure TPatternAddInForm.ClearPatternRows;
var
  I: Integer;
begin
  for I := PatternRows.Count - 1 downto 0 do
    PPatternItemRow(PatternRows.Items[I]).Free;
  PatternInspector.ClearRows;
  PatternRows.Clear;
end;

procedure TPatternAddInForm.ApplyPattern;
begin
  try
    FPattern.ApplyPattern;
  except on E: Exception do
    Application.MessageBox(PChar(E.Message), PChar(Application.Title),
      MB_OK + MB_ICONERROR);
  end;
end;

procedure TPatternAddInForm.ShowDescription(PID: PPattern);
var
  Param: PPatternParameter;
  TI: TListItem;
  Str, Str2: string;
  I, J: Integer;
begin
  ResultInfoListView.Clear;

  PatternNameLabel.Caption := Format(TXT_PATTERN_NAME, [PID.Name]);
  for I := 0 to PID.PatternParameterCount - 1 do begin
    Str := '';
    Param := PID.Parameters[I];
    TI := ResultInfoListView.Items.Add;
    TI.Caption := Param.Caption;
    case Param.ParamType of
      ptInteger: Str := Str + Param.Value;
      ptBoolean: Str := Str + Param.Value;
      ptString: Str := Str + Param.Value;
      ptEnumeration: Str := Str + Param.Value;
      ptElement:
        begin
          if Param.ElementValueCount > 0 then
            Str := Str + Param.ElementValues[0].Name
          else
            Str := Str + Param.Value;
        end;
      ptElementList:
        begin
          Str2 := '';
          for J := 0 to Param.ElementValueCount - 1 do begin
            Str2 := Str2 + Param.ElementValues[J].Name;
            if J <> Param.ElementValueCount - 1 then Str2 := Str2 + ', ';
          end;
          if Param.Value <> '' then begin
            if Str2 <> '' then Str2 := Str2 + ', ' + Param.Value
            else Str2 := Param.Value;
          end;
          Str := Str + Str2;
        end;
    end;
    TI.SubItems.Add(Str);
  end;
end;

function TPatternAddInForm.FindPatternRow(Row: TdxInspectorRow): PPatternItemRow;
var
  PatternRow: PPatternItemRow;
  I: Integer;
begin
  Result := nil;
  for I := 0 to PatternRows.Count - 1 do begin
    PatternRow := PPatternItemRow(PatternRows[I]);
    if PatternRow.InspectorRow = Row then
      Result := PatternRow;
  end;
end;

function TPatternAddInForm.AssignInspectorRowValues: Boolean;
var
  I: Integer;
  ItemRow: PPatternItemRow;
begin
  Result := False;
  try
    for I := 0 to PatternRows.Count - 1 do begin
      ItemRow := PatternRows.Items[I];
      ItemRow.AssignParameterValue;
    end;
    Result := True;
  except on E: EInvalidParameterValue do
    begin
      Application.MessageBox(PChar(E.Message), PChar(Application.Title),
                             MB_OK + MB_ICONERROR);
    end;
  end;
end;

// TPatternAddInForm
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PPatternItemRow

constructor PPatternItemRow.Create(AInspector: TdxInspector;
  APatternParameter: PPatternParameter; ParentRow: TdxInspectorRow);
begin
  inherited Create;
  FInspector := AInspector;
  FPatternParameter := APatternParameter;
  FParentRow := ParentRow;
  CreateInspectorRow;
end;

function PPatternItemRow.FindExistElement(ElemName: string): IUMLElement;
var
  Dgm: IDiagram;
  DgmOwner: IModel;
begin
  Result := nil;
  if ElemName = '' then Exit;
  Dgm := PatternAddInForm.StarUMLApp.SelectionManager.ActiveDiagram;
  DgmOwner := Dgm.DiagramOwner;
  Result := DgmOwner.FindByName(ElemName) as IUMLElement;
end;

procedure PPatternItemRow.AssignParameterValue;
begin
  // nothing to to
end;

// PPatternItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PIntegerPatternItemRow

procedure PIntegerPatternItemRow.CreateInspectorRow;
begin
  inherited;
  FInspectorRow := FParentRow.Node.AddChildEx(TdxInspectorTextRow).Row;
  DrawInspector;
end;

procedure PIntegerPatternItemRow.DrawInspector;
var
  TextRow: TdxInspectorTextRow;
begin
  inherited;
  FInspectorRow.Caption := FPatternParameter.Caption;
  TextRow := FInspectorRow as TdxInspectorTextRow;
  TextRow.Text := FPatternParameter.DefaultValue;
  FPatternParameter.Value := TextRow.Text;
end;

procedure PIntegerPatternItemRow.AssignParameterValue;
var
  Str: string;
  V, Code: Integer;
begin
  inherited;
  Str := Trim((FInspectorRow as TdxInspectorTextRow).Text);
  if Str = '' then
    raise EInvalidParameterValue.Create(Format(ERR_EMPTY_PARAM_VALUE, [FPatternParameter.Caption]));
  Val(Str, V, Code);
  if Code <> 0 then
    raise EInvalidParameterValue.Create(Format(ERR_INVALID_PARAM_VALUE, [FPatternParameter.Caption, 'Integer']));
  FPatternParameter.Value := Str;
end;

// PIntegerPatternItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PBooleanPatternItemRow

procedure PBooleanPatternItemRow.CreateInspectorRow;
var
  CheckRow: TdxInspectorTextCheckRow;
begin
  inherited;
  FInspectorRow := FParentRow.Node.AddChildEx(TdxInspectorTextCheckRow).Row;
  CheckRow := FInspectorRow as TdxInspectorTextCheckRow;
  CheckRow.ValueChecked := VALUE_TRUE;
  CheckRow.ValueUnchecked := VALUE_FALSE;
  DrawInspector;
end;

procedure PBooleanPatternItemRow.DrawInspector;
var
  CheckRow: TdxInspectorTextCheckRow;
begin
  inherited;
  FInspectorRow.Caption := FPatternParameter.Caption;
  CheckRow := FInspectorRow as TdxInspectorTextCheckRow;
  CheckRow.Text := FPatternParameter.DefaultValue;
  FPatternParameter.Value := CheckRow.Text;
end;

procedure PBooleanPatternItemRow.AssignParameterValue;
begin
  inherited;
  FPatternParameter.Value := (FInspectorRow as TdxInspectorTextCheckRow).Text;
end;

// PBooleanPatternItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PStringPatternItemRow

procedure PStringPatternItemRow.CreateInspectorRow;
begin
  inherited;
  FInspectorRow := FParentRow.Node.AddChildEx(TdxInspectorTextRow).Row;
  DrawInspector;
end;

procedure PStringPatternItemRow.DrawInspector;
var
  TextRow: TdxInspectorTextRow;
begin
  inherited;
  FInspectorRow.Caption := FPatternParameter.Caption;
  TextRow := FInspectorRow as TdxInspectorTextRow;
  TextRow.Text := FPatternParameter.DefaultValue;
  FPatternParameter.Value := TextRow.Text;
end;

procedure PStringPatternItemRow.AssignParameterValue;
var
  Str: string;
begin
  inherited;
  Str := Trim((FInspectorRow as TdxInspectorTextRow).Text);
  if Str = '' then
    raise EInvalidParameterValue.Create(Format(ERR_EMPTY_PARAM_VALUE, [FPatternParameter.Caption]));
  FPatternParameter.Value := Str;
end;

// PStringPatternItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PEnumerationPatternItemRow

procedure PEnumerationPatternItemRow.PickRowCloseUp(Sender: TObject; var Value: Variant;
  var Accept: Boolean);
begin
  if (Sender as TdxInspectorTextPickRow).Text <> Value then 
    (Sender as TdxInspectorTextPickRow).Text := Value;
end;

procedure PEnumerationPatternItemRow.CreateInspectorRow;
begin
  inherited;
  FInspectorRow := FParentRow.Node.AddChildEx(TdxInspectorTextPickRow).Row;
  DrawInspector;
end;

procedure PEnumerationPatternItemRow.DrawInspector;
var
  TextPickRow: TdxInspectorTextPickRow;
  I: Integer;
begin
  inherited;
  FInspectorRow.Caption := FPatternParameter.Caption;
  TextPickRow := FInspectorRow as TdxInspectorTextPickRow;
  for I := 0 to FPatternParameter.EnumerationLiterals.Count - 1 do
    TextPickRow.Items.Add(FPatternParameter.EnumerationLiterals.Strings[I]);
  TextPickRow.Text := FPatternParameter.DefaultValue;
  TextPickRow.DropDownListStyle := True;
  TextPickRow.ReadOnly := True;
  TextPickRow.OnCloseUp := PickRowCloseUp;
  FPatternParameter.Value := TextPickRow.Text;
end;

procedure PEnumerationPatternItemRow.AssignParameterValue;
var
  Str: string;
begin
  inherited;
  Str := Trim((FInspectorRow as TdxInspectorTextPickRow).Text);
  FPatternParameter.Value := Str;
end;

// PEnumerationPatternItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PElementPatternItemRow

procedure PElementPatternItemRow.CreateInspectorRow;
begin
  inherited;
  FInspectorRow := FParentRow.Node.AddChildEx(TdxInspectorTextButtonRow).Row;
  DrawInspector;
end;

procedure PElementPatternItemRow.DrawInspector;
var
  TextBtRow: TdxInspectorTextButtonRow;
begin
  inherited;
  FInspectorRow.Caption := FPatternParameter.Caption;
  TextBtRow := FInspectorRow as TdxInspectorTextButtonRow;
  TextBtRow.OnButtonClick := HandleBtnClick;
  if (FPatternParameter.ElementKind = pkModel) or
     (FPatternParameter.ElementKind = pkSubsystem) or
     (FPatternParameter.ElementKind = pkPackage) or
     (FPatternParameter.ElementKind = pkClass) or
     (FPatternParameter.ElementKind = pkInterface)
  then
    TextBtRow.Text := FPatternParameter.DefaultValue
  else begin
    TextBtRow.Text := '';
    TextBtRow.ReadOnly := True;
  end;

  FPatternParameter.Value := TextBtRow.Text;
end;

procedure PElementPatternItemRow.HandleBtnClick(Sender: TObject; AbsoluteIndex: Integer);
var
  ElementSelector: IElementSelector;
  Elem: IUMLElement;
  ElemName, Str: string;
begin
  ElementSelector := PatternAddInForm.StarUMLApp.ElementSelector;
  ElementSelector.AllowNull := False;
  // filtering
  if (FPatternParameter.ElementKind = pkPackage) or
     (FPatternParameter.ElementKind = pkModel) or
     (FPatternParameter.ElementKind = pkSubsystem)
  then ElementSelector.Filter(fkPackages)
  else if (FPatternParameter.ElementKind = pkClass) or
          (FPatternParameter.ElementKind = pkInterface)
  then ElementSelector.Filter(fkClassifiers)
  else ElementSelector.Filter(fkAll);
  // set selectable model
  ElementSelector.ClearSelectableModels;
  case FPatternParameter.ElementKind of
    pkPackage: ElementSelector.AddSelectableModel('UMLPackage');
    pkModel: ElementSelector.AddSelectableModel('UMLModel');
    pkSubsystem: ElementSelector.AddSelectableModel('UMLSubsystem');
    pkClass: ElementSelector.AddSelectableModel('UMLClass');
    pkInterface: ElementSelector.AddSelectableModel('UMLInterface');
    pkAttribute: ElementSelector.AddSelectableModel('UMLAttribute');
    pkOperation: ElementSelector.AddSelectableModel('UMLOperation');
    pkLiteral: ElementSelector.AddSelectableModel('UMLEnumerationLiteral');
    pkParameter: ElementSelector.AddSelectableModel('UMLParameter');
  end;
  // execute
  Str := Format(TXT_SELECT_PARAM_ELEM, [FPatternParameter.Caption]);
  if ElementSelector.Execute(Str) then begin
    Elem := ElementSelector.GetSelectedModel as IUMLElement;
    ElemName := Elem.Name;
    FPatternParameter.ClearElementValues;
    (FInspectorRow as TdxInspectorTextButtonRow).Text := ElemName;
    FPatternParameter.AddElementValue(Elem);
  end;
end;

procedure PElementPatternItemRow.AssignParameterValue;
var
  Str: string;
  Elem: IUMLElement;
begin
  inherited;
  Str := Trim((FInspectorRow as TdxInspectorTextButtonRow).Text);
  if Str = '' then
    raise EInvalidParameterValue.Create(Format(ERR_EMPTY_PARAM_VALUE, [FPatternParameter.Caption]));

  if FPatternParameter.ElementValueCount > 0 then begin
    Elem := FPatternParameter.ElementValues[0];
    if LowerCase(Trim(Elem.Name)) <> LowerCase(Str) then begin
      FPatternParameter.ClearElementValues;
    end;
  end;

  if FPatternParameter.ElementValueCount = 0 then begin
    Elem := FindExistElement(Str);
    if Elem <> nil then begin
      case FPatternParameter.ElementKind of
        pkPackage:
          if Elem.GetClassName <> 'UMLPackage' then
            raise EInvalidParameterValue.Create(Format(ERR_ELEM_NAME_CONFLICT,
                                                 [FPatternParameter.Caption]));
        pkModel:
          if Elem.GetClassName <> 'UMLModel' then
            raise EInvalidParameterValue.Create(Format(ERR_ELEM_NAME_CONFLICT,
                                                 [FPatternParameter.Caption]));
        pkSubsystem:
          if Elem.GetClassName <> 'UMLSubsystem' then
            raise EInvalidParameterValue.Create(Format(ERR_ELEM_NAME_CONFLICT,
                                                 [FPatternParameter.Caption]));
        pkClass:
          if Elem.GetClassName <> 'UMLClass' then
            raise EInvalidParameterValue.Create(Format(ERR_ELEM_NAME_CONFLICT,
                                                 [FPatternParameter.Caption]));
        pkInterface:
          if Elem.GetClassName <> 'UMLInterface' then
            raise EInvalidParameterValue.Create(Format(ERR_ELEM_NAME_CONFLICT,
                                                 [FPatternParameter.Caption]));
      end;
      FPatternParameter.AddElementValue(Elem);
    end;
  end;

  FPatternParameter.Value := Str;
end;

// PElementPatternItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PElementListPatternItemRow

procedure PElementListPatternItemRow.CreateInspectorRow;
begin
  inherited;
  FInspectorRow := FParentRow.Node.AddChildEx(TdxInspectorTextButtonRow).Row;
  DrawInspector;
end;

procedure PElementListPatternItemRow.DrawInspector;
var
  TextBtRow: TdxInspectorTextButtonRow;
begin
  inherited;
  FInspectorRow.Caption := FPatternParameter.Caption;
  TextBtRow := FInspectorRow as TdxInspectorTextButtonRow;
  TextBtRow.OnButtonClick := HandleBtnListClick;
  if (FPatternParameter.ElementKind = pkModel) or
     (FPatternParameter.ElementKind = pkSubsystem) or
     (FPatternParameter.ElementKind = pkPackage) or
     (FPatternParameter.ElementKind = pkClass) or
     (FPatternParameter.ElementKind = pkInterface)
  then
    TextBtRow.Text := FPatternParameter.DefaultValue
  else begin
    TextBtRow.Text := '';
    TextBtRow.ReadOnly := True;
  end;
end;

procedure PElementListPatternItemRow.HandleBtnListClick(Sender: TObject;
  AbsoluteIndex: Integer);
var
  I: Integer;
  Elem: IUMLElement;
  Str: string;
begin
  PatternParamColEditFrm := TPatternParamColEditFrm.Create(nil);
  try
    PatternParamColEditFrm.StarUMLApp := PatternAddInForm.StarUMLApp;
    PatternParamColEditFrm.ElemKind := FPatternParameter.ElementKind;
    PatternParamColEditFrm.ElementSelectorCaption := FPatternParameter.Caption;
    for I := 0 to FPatternParameter.ElementValueCount - 1 do begin
      Elem := FPatternParameter.ElementValues[I];
      PatternParamColEditFrm.AddElement(Elem);
    end;
    if PatternParamColEditFrm.Execute then begin
      if PatternParamColEditFrm.Changed then begin
        (FInspectorRow as TdxInspectorTextButtonRow).Text := '';
        FPatternParameter.ClearElementValues;
        Str := '';
        for I := 0 to PatternParamColEditFrm.ElementCount - 1 do begin
          Elem := PatternParamColEditFrm.Element[I];
          FPatternParameter.AddElementValue(Elem);
          Str := Str + Elem.Name;
          if I < PatternParamColEditFrm.ElementCount - 1 then Str := Str + ', ';
        end;
        if str <> '' then begin
          (FInspectorRow as TdxInspectorTextButtonRow).Text := Str;
        end;
      end;
    end;
  finally
    PatternParamColEditFrm.Free;
  end;
end;

procedure PElementListPatternItemRow.AssignParameterValue;
var
  SL: TStringList;
  Str, TempStr: string;
  I, J: Integer;
  B: Boolean;
  Elem: IUMLElement;
begin
  inherited;
  Str := Trim((FInspectorRow as TdxInspectorTextButtonRow).Text);
  if Str = '' then begin
    FPatternParameter.ClearElementValues;
    FPatternParameter.Value := '';
    Exit;
  end;
  if (FPatternParameter.ElementKind = pkAttribute) or
     (FPatternParameter.ElementKind = pkOperation) or
     (FPatternParameter.ElementKind = pkLiteral) or
     (FPatternParameter.ElementKind = pkParameter)
  then Exit;

  FPatternParameter.Value := '';
  SL := TStringList.Create;
  try
    SeparateStringByComma(Str, SL);
    Str := '';
    for I := 0 to SL.Count - 1 do begin
      TempStr := '';
      TempStr := SL.Strings[I];
      B := False;
      for J := 0 to FPatternParameter.ElementValueCount - 1 do begin
        if LowerCase(FPatternParameter.ElementValues[J].Name) = LowerCase(TempStr) then
        begin
          B := True;
          Break;
        end;
      end;
      if not B then begin
        Elem := FindExistElement(TempStr);
        if Elem <> nil then begin
          case FPatternParameter.ElementKind of
            pkPackage:
              if Elem.GetClassName <> 'UMLPackage' then
                raise EInvalidParameterValue.Create(Format(ERR_ELEM_NAME_CONFLICT,
                                                     [FPatternParameter.Caption]));
            pkModel:
              if Elem.GetClassName <> 'UMLModel' then
                raise EInvalidParameterValue.Create(Format(ERR_ELEM_NAME_CONFLICT,
                                                     [FPatternParameter.Caption]));
            pkSubsystem:
              if Elem.GetClassName <> 'UMLSubsystem' then
                raise EInvalidParameterValue.Create(Format(ERR_ELEM_NAME_CONFLICT,
                                                     [FPatternParameter.Caption]));
            pkClass:
              if Elem.GetClassName <> 'UMLClass' then
                raise EInvalidParameterValue.Create(Format(ERR_ELEM_NAME_CONFLICT,
                                                     [FPatternParameter.Caption]));
            pkInterface:
              if Elem.GetClassName <> 'UMLInterface' then
                raise EInvalidParameterValue.Create(Format(ERR_ELEM_NAME_CONFLICT,
                                                     [FPatternParameter.Caption]));
          end;
          FPatternParameter.AddElementValue(Elem);
        end else begin
          if Str <> '' then Str := Str + ', ' + TempStr
          else Str := TempStr;
        end;
      end;
    end;
    FPatternParameter.Value := Str;
  finally
    SL.Free;
  end;
end;

// PElementListPatternItemRow
////////////////////////////////////////////////////////////////////////////////

procedure TPatternAddInForm.FormCreate(Sender: TObject);
begin
  NLSManager.SetFile(GetDllPath + '\' + NLS_FILE_NAME);
  NLSManager.TranslateComponent(Self, []);
  PatternManager := PPatternManager.Create;
  PatternRows := TList.Create;
end;

procedure TPatternAddInForm.FormDestroy(Sender: TObject);
begin
  ClearPatternRows;
  PatternRows.Free;
  PatternManager.StarUMLApp := nil;
  PatternManager.Free;
end;

procedure TPatternAddInForm.FormShow(Sender: TObject);
begin
  PatternManager.StarUMLApp := StarUMLApp;
  PatternManager.ScanPatternRepository(GetDllPath + '\');
  BuildPatternTreeView;
  PatternGenWizard.SelectFirstPage;
  SelectPatternPage.EnabledButtons := [bkHelp, bkCancel];
  SelectPatternPage.EnabledButtons := [bkCancel];
  PatternHelpButton.Enabled := False;
end;

procedure TPatternAddInForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PatternMemo.Clear;
  DescriptionMemo.Lines.Clear;
  ClearPatternRows;
end;

procedure TPatternAddInForm.PatternTreeViewChange(Sender: TObject; Node: TTreeNode);
var
  PN: PPatternNode;
  PT: PatternDef.PPattern;
begin
  PN := Node.Data;
  if PN is PatternDef.PPattern then begin
    PT := PN as PatternDef.PPattern;
    DescriptionMemo.Lines.Clear;
    PatternMemo.Clear;
    try
      PT.LoadPattern;

      DescriptionMemo.Lines.Add(PT.Description);
      // 스크롤되어 description이 다 보이지 않는 현상 방지
      DescriptionMemo.SelStart := 0;
      DescriptionMemo.SelLength := 0;
      SelectPatternPage.EnabledButtons := [bkHelp, bkNext, bkCancel];
      SelectPatternPage.EnabledButtons := [bkNext, bkCancel];
      PatternHelpButton.Enabled := True;
      BuildPatternInspectorView(PatternInspector, PN);
      PatternRef := PT;
    except on E: Exception do
      begin
        SelectPatternPage.EnabledButtons := [bkHelp, bkCancel];
        PatternHelpButton.Enabled := False;
        Application.MessageBox(PChar(E.Message), PChar(Application.Title),
          MB_OK + MB_ICONERROR);
      end;
    end;
  end else begin
    DescriptionMemo.Lines.Clear;
    SelectPatternPage.EnabledButtons := [bkHelp, bkCancel];
    PatternHelpButton.Enabled := False;
  end;
end;

procedure TPatternAddInForm.PatternParameterPageNextButtonClick(
  Sender: TObject; var Stop: Boolean);
begin
  if AssignInspectorRowValues then ShowDescription(Self.FPattern)
  else Stop := True;
end;

procedure TPatternAddInForm.PatternResultPageFinishButtonClick(
  Sender: TObject; var Stop: Boolean);
begin
  ApplyPattern;
end;

procedure TPatternAddInForm.SelectPatternPageCancelButtonClick(Sender: TObject; var Stop: Boolean);
begin
  Stop := not (Application.MessageBox(PChar(QUERY_CANCEL_APPLY_PATTERN), PChar(Application.Title),
          MB_YESNO + MB_ICONQUESTION) = IDYES);
end;

procedure TPatternAddInForm.PatternTreeViewCollapsed(Sender: TObject; Node: TTreeNode);
var
  PN: PPatternNode;
begin
  PN := Node.Data;
  if PN is PatternDef.PPatternFolder then Node.StateIndex := 3;
end;

procedure TPatternAddInForm.PatternTreeViewExpanded(Sender: TObject; Node: TTreeNode);
var
  PN: PPatternNode;
begin
  PN := Node.Data;
  if PN is PatternDef.PPatternFolder then Node.StateIndex := 4;
end;

procedure TPatternAddInForm.PatternHelpButtonClick(Sender: TObject);
var
  TN: TTreeNode;
  PN: PPatternNode;
  PT: PPattern;
  HelpFile: string;
begin
  TN := PatternTreeView.Selected;
  if TN = nil then Exit;

  PN := TN.Data;
  if PN is PPattern then begin
    PT := PN as PPattern;
    HelpFile := PT.FullPathName + PT.HelpFile;
    if not FileExists(HelpFile) then begin
      Application.MessageBox(PChar(ERR_HELPFILE_NOT_FOUND), PChar(Application.Title),
        MB_OK + MB_ICONERROR);
      Exit;
    end;

    try
      ShellExecute(0, 'open', PChar(HelpFile), nil, nil, SW_SHOW);
    except on E: Exception do
      Application.MessageBox(PChar(E.Message), PChar(Application.Title),
        MB_OK + MB_ICONERROR);
    end;
  end;
end;

procedure TPatternAddInForm.PatternInspectorChangeNode(Sender: TObject;
  OldNode, Node: TdxInspectorNode);
var
  PatternRow: PPatternItemRow;
  PD: PPatternParameter;
begin
  if Node is TdxInspectorRowNode then begin
    PatternRow := FindPatternRow((Node as TdxInspectorRowNode).Row);
    if PatternRow <> nil then begin
      PD:= PatternRow.FPatternParameter;
      PatternMemo.Clear;
      PatternMemo.Lines.Add(PD.Description);
      PatternMemo.SelStart := 0;
      PatternMemo.SelLength := 0;
    end;
  end;
end;

end.

