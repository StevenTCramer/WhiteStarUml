unit PropEdt;

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

// =============================================================================
//
// GUI component development notice
// --------------------------------
//
//   (1) GUI component is inherited from TCustomPanel.
//   (2) The visibility of OnEnter and OnExit Events is public.
//   (3) catch OnEnter, OnExit Events of controls contained in GUI component,
//       let self to fire OnEnter, OnExit events
//   (4) set BevelInner, BevelOuter to 'bvNone'
//
// =============================================================================

interface

uses
  BasicClasses,
  Core,
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ImgList,
  ExtCtrls,
  FlatPanel,
  cxStyles,
  cxGraphics,
  cxControls,
  cxEdit,
  cxInplaceContainer,
  cxVGrid,
  cxCheckComboBox,
  cxTextEdit,
  cxButtonEdit,
  cxDBLookupComboBox,
  cxImage,
  cxImageComboBox,
  cxCheckBox,
  cxDropDownEdit;

type
  // Forward Declarations;
  TPropertyEditor = class;

  // PRowKind
  PRowKind = (rkTextRow, rkTextButtonRow, rkChoiceRow, rkCheckRow, rkTextChoiceRow);

  // Events
  PPropertySelectedEvent = procedure(Sender: TObject; PropertyName: string) of object;

  // PProperty
  PProperty = class
  public
    Key: string;
    Category: string;
    Caption: string;
    RowKind: PRowKind;
    RowEditable: Boolean;
    IsUnique: Boolean;
    OnlyTheSameKind: Boolean;
    ImageIndex: Integer;
    Locked: Boolean;
    RowItemValues: TStrings;
    RowItemImages: TImageList;
    RowItemImageIndexes: TStrings;
    constructor Create(AKey, ACategory, ACaption: string; ARowKind: PRowKind);
    destructor Destroy; override;
  end;

  // PPropertySpecifier
  PPropertySpecifier = class
  private
    FProperties: TList;
    function GetProperty(Index: Integer): PProperty;
    function GetPropertyCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure ClearProperties;
    procedure EmptyProperties;
    function ContainsProperty(AKey: string): Boolean;
    function DefineProperty(AKey, ACategory, ACaption: string; ARowKind: PRowKind): PProperty;
    property Properties[Index: Integer]: PProperty read GetProperty;
    property PropertyCount: Integer read GetPropertyCount;
  end;

  // PAbstractPropertyAdaptor
  PAbstractPropertyAdaptor = class
  private
    FPropertyEditor: TPropertyEditor;
  protected
    FReadOnly: Boolean;
  public
    procedure SpecifyProperties(AElement: PElement; APropertySpecifier: PPropertySpecifier); virtual; abstract;
    function GetPropertyValue(AElement: PElement; Key: string): string; virtual; abstract;
    procedure SetPropertyValue(AElementSet: POrderedSet; Key: string; Value: string); virtual; abstract;
    procedure PropertyButtonClicked(AElementSet: POrderedSet; Key: string); virtual; abstract;
    property ReadOnly: Boolean read FReadOnly;
    property PropertyEditor: TPropertyEditor read FPropertyEditor;
  end;

  TPropertyEditor = class(TFrame)
    RowImageList: TImageList;
    AggregationImageList: TImageList;
    VisibilityImageList: TImageList;
    ClientPanel: TFlatPanel;
    PsedostatsImageList: TImageList;
    ActionKindImageList: TImageList;
    Inspector: TcxVerticalGrid;

  private
    PropertyList: TList;
    RowList: TList;
    PropertySpecifier: PPropertySpecifier;
    FReadOnly: Boolean;
    FPropertyAdaptor: PAbstractPropertyAdaptor;
    FInspectingElements: POrderedSet;
    FOnPropertySelected: PPropertySelectedEvent;
    procedure SetReadOnly(Value: Boolean);
    function GetInspectingElement(Index: Integer): PElement;
    function GetInspectingElementCount: Integer;
    procedure SetPropertyAdaptor(Value: PAbstractPropertyAdaptor);
    procedure EmptyPropertyList;
    procedure InitializeGUI;
    procedure ClearRows;
    procedure CollectProperties;
    procedure SetupRows;
    procedure InspectorDrawValue(Sender: TObject; ACanvas: TcxCanvas; APainter: TcxvgPainter; AValueInfo: TcxRowValueInfo; var Done: Boolean);
    procedure InspectorItemChanged(Sender: TObject; AOldRow: TcxCustomRow; AOldCellIndex: Integer);
    procedure InspectorEdited(Sender: TObject; ARowProperties: TcxCustomEditorRowProperties);
    procedure PropertyModified(Sender: TObject; ARowProperties: TcxCustomEditorRowProperties);
    procedure RowButtonClick(Sender: TObject; AbsoluteIndex: Integer);
    procedure EnterHandler(Sender: TObject);
  protected
    procedure SetEnabled(Value: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ClearInspectingElements;
    procedure AddInspectingElement(AElement: PElement);
    procedure RemoveInspectingElement(AElement: PElement);
    procedure InspectElements;
    procedure UpdateProperties;
    procedure ApplyChanges;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly;
    property InspectingElements[Index: Integer]: PElement read GetInspectingElement;
    property InspectingElementCount: Integer read GetInspectingElementCount;
    property PropertyAdaptor: PAbstractPropertyAdaptor read FPropertyAdaptor write SetPropertyAdaptor;
    property OnPropertySelected: PPropertySelectedEvent read FOnPropertySelected write FOnPropertySelected;
  end;

implementation

{$R *.dfm}

uses
  Variants;

////////////////////////////////////////////////////////////////////////////////
// PProperty

constructor PProperty.Create(AKey, ACategory, ACaption: string; ARowKind: PRowKind);
begin
  Key := AKey;
  Category := ACategory;
  Caption := ACaption;
  RowKind := ARowKind;
  RowEditable := True;
  IsUnique := False;
  OnlyTheSameKind := False;
  ImageIndex := -1;
  RowItemValues := TStringList.Create;
  RowItemImageIndexes := TStringList.Create;
end;

destructor PProperty.Destroy;
begin
  RowItemValues.Free;
  RowItemValues := nil;
  RowItemImageIndexes.Free;
  RowItemImageIndexes := nil;
  inherited;
end;

// PProperty
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PPropertySpecifier

constructor PPropertySpecifier.Create;
begin
  inherited;
  FProperties := TList.Create;
end;

destructor PPropertySpecifier.Destroy;
begin
  EmptyProperties;
  FProperties.Free;
  inherited;
end;

function PPropertySpecifier.GetProperty(Index: Integer): PProperty;
begin
  Result := FProperties.Items[Index];
end;

function PPropertySpecifier.GetPropertyCount: Integer;
begin
  Result := FProperties.Count;
end;

procedure PPropertySpecifier.ClearProperties;
begin
  FProperties.Clear;
end;

procedure PPropertySpecifier.EmptyProperties;
var
  I: Integer;
  P: PProperty;
begin
  for I := FProperties.Count - 1 downto 0 do
  begin
    P := FProperties.Items[I];
    P.Free;
  end;
  FProperties.Clear;
end;

function PPropertySpecifier.ContainsProperty(AKey: string): Boolean;
var
  I: Integer;
  P: PProperty;
begin
  for I := 0 to FProperties.Count - 1 do
  begin
    P := FProperties.Items[I];
    if P.Key = AKey then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

function PPropertySpecifier.DefineProperty(AKey, ACategory, ACaption: string; ARowKind: PRowKind): PProperty;
var
  P: PProperty;
begin
  P := PProperty.Create(AKey, ACategory, ACaption, ARowKind);
  FProperties.Add(P);
  Result := P;
end;

// PPropertySpecifier
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// TPropertyEditor

constructor TPropertyEditor.Create(AOwner: TComponent);
begin
  inherited;
  PropertyList := TList.Create;
  RowList := TList.Create;
  PropertySpecifier := PPropertySpecifier.Create;
  FInspectingElements := POrderedSet.Create;
  InitializeGUI;
end;

destructor TPropertyEditor.Destroy;
begin
  EmptyPropertyList;
  PropertyList.Free;
  PropertyList := nil;
  RowList.Free;
  RowList := nil;
  PropertySpecifier.Free;
  PropertySpecifier := nil;
  FInspectingElements.Free;
  FInspectingElements := nil;
  inherited;
end;

procedure TPropertyEditor.SetReadOnly(Value: Boolean);
begin
  FReadOnly := Value;
  FPropertyAdaptor.FReadOnly := Value;
  InspectElements;
end;

function TPropertyEditor.GetInspectingElement(Index: Integer): PElement;
begin
  Result := FInspectingElements.Items[Index] as PElement;
end;

function TPropertyEditor.GetInspectingElementCount: Integer;
begin
  Result := FInspectingElements.Count;
end;

procedure TPropertyEditor.SetPropertyAdaptor(Value: PAbstractPropertyAdaptor);
begin
  if FPropertyAdaptor <> Value then
  begin
    if FPropertyAdaptor <> nil then FPropertyAdaptor.FPropertyEditor := nil;
    FPropertyAdaptor := Value;
    if FPropertyAdaptor <> nil then FPropertyAdaptor.FPropertyEditor := Self;
  end;
end;

procedure TPropertyEditor.EmptyPropertyList;
var
  I: Integer;
  P: PProperty;
begin
  for I := PropertyList.Count - 1 downto 0 do
  begin
    P := PropertyList.Items[I];
    P.Free;
  end;
  PropertyList.Clear;
end;

procedure TPropertyEditor.InitializeGUI;
begin
  Inspector.OnEdited := InspectorEdited;
  Inspector.OnEnter := EnterHandler;
  Inspector.OnDrawValue := InspectorDrawValue;
  Inspector.OnItemChanged := InspectorItemChanged;
end;

procedure TPropertyEditor.ClearRows;
begin
  if Inspector <> nil then Inspector.ClearRows;
  RowList.Clear;
end;

procedure TPropertyEditor.CollectProperties;
var
  I: Integer;
  IsDiffKind: Boolean;
  FirstElement: PElement;

  procedure Intersect(APropertyList: TList; APropertySpecifier: PPropertySpecifier; IsDiffKind: Boolean);
  var
    J: Integer;
    P: PProperty;
  begin
    for J := APropertyList.Count - 1 downto 0 do
    begin
      P := APropertyList.Items[J];
      if (not APropertySpecifier.ContainsProperty(P.Key)) or P.IsUnique
        or (IsDiffKind and P.OnlyTheSameKind) then
      begin
        APropertyList.Remove(P);
        P.Free;
      end;
    end;
  end;

begin
  EmptyPropertyList;
  // Inspecting single element
  if FInspectingElements.Count = 1 then
  begin
    PropertySpecifier.EmptyProperties;
    PropertyAdaptor.SpecifyProperties(FInspectingElements.Items[0] as PElement, PropertySpecifier);
    PropertyList.Assign(PropertySpecifier.FProperties);
    PropertySpecifier.ClearProperties;
  end
  // Inspecting multiple elements
  else if InspectingElementCount > 1 then
  begin
    // Setting First element
    FirstElement := FInspectingElements.Items[0] as PElement;
    PropertySpecifier.EmptyProperties;
    PropertyAdaptor.SpecifyProperties(FirstElement, PropertySpecifier);
    PropertyList.Assign(PropertySpecifier.FProperties);
    PropertySpecifier.ClearProperties;
    // Intersect properties of first element with that of consequent elements
    IsDiffKind := False;
    for I := 1 to FInspectingElements.Count - 1 do
    begin
      IsDiffKind := IsDiffKind or ((FInspectingElements.Items[I] as PElement).MetaClass.Name <> FirstElement.MetaClass.Name);
      PropertySpecifier.EmptyProperties;
      PropertyAdaptor.SpecifyProperties(FInspectingElements.Items[I] as PElement, PropertySpecifier);
      Intersect(PropertyList, PropertySpecifier, IsDiffKind);
    end;
    PropertySpecifier.EmptyProperties;
  end;
end;

procedure TPropertyEditor.SetupRows;
var
  I: Integer;
  P: PProperty;
  SuperNode: TcxCategoryRow;
  SubNode: TcxCustomRow;
  CategoryRows: TStringList;
  lcxEditorRow: TcxEditorRow;
  lcxCustomRow: TcxCustomRow;
  lcxTextEditProperties: TcxTextEditProperties;
  lcxButtonEditProperties: TcxButtonEditProperties;
  lcxImageComboBoxProperties: TcxImageComboBoxProperties;
  lcxComboBoxProperties: TcxComboBoxProperties;
  lcxImageProperties: TcxImageProperties;
  lcxImageComboBoxItem: TcxImageComboBoxItem;
  lcxCheckBoxProperties: TcxCheckBoxProperties;
  lIndexOptions: Integer;

  function GetCategoryRow(Category: string): TcxCategoryRow;
  var
    Index: Integer;
  begin
    Index := CategoryRows.IndexOf(Category);
    if Index = -1 then
    begin
      Result := Inspector.Add(TcxCategoryRow) as TcxCategoryRow;
      Result.Properties.Caption := Category;
      CategoryRows.AddObject(Category, Result);
    end else
    begin
      Result := TcxCategoryRow(CategoryRows.Objects[Index]);
    end;
  end;

begin
  Inspector.BeginUpdate;
  ClearRows;
  CategoryRows := TStringList.Create;
  try
    for I := 0 to PropertyList.Count - 1 do
    begin
      P := PropertyList.Items[I];
      SuperNode := GetCategoryRow(P.Category);
    // Row creation
      case P.RowKind of
        rkTextRow:
          begin
            lcxEditorRow := Inspector.AddChild(SuperNode, TcxEditorRow) as TcxEditorRow;
            lcxEditorRow.Properties.EditPropertiesClass := TcxTextEditProperties;
            lcxTextEditProperties := lcxEditorRow.Properties.EditProperties as TcxTextEditProperties;
            lcxTextEditProperties.ReadOnly := (not P.RowEditable) or FReadOnly;
          end;
        rkTextButtonRow:
          begin
            lcxEditorRow := Inspector.AddChild(SuperNode, TcxEditorRow) as TcxEditorRow;
            lcxEditorRow.Properties.EditPropertiesClass := TcxButtonEditProperties;
            lcxButtonEditProperties := lcxEditorRow.Properties.EditProperties as TcxButtonEditProperties;
            lcxButtonEditProperties.ReadOnly := (not P.RowEditable) or FReadOnly;
            ;
            lcxButtonEditProperties.OnButtonClick := RowButtonClick;
          end;
        rkChoiceRow:
          begin
            lcxEditorRow := Inspector.AddChild(SuperNode, TcxEditorRow) as TcxEditorRow;
            lcxEditorRow.Properties.EditPropertiesClass := TcxImageComboBoxProperties;
            lcxImageComboBoxProperties := lcxEditorRow.Properties.EditProperties as TcxImageComboBoxProperties;
            lcxImageComboBoxProperties.ShowDescriptions := True;
            lcxImageComboBoxProperties.Images := P.RowItemImages;
            lcxImageComboBoxProperties.ReadOnly := FReadOnly;
            lcxImageComboBoxProperties.DefaultImageIndex := 0;
            lcxImageComboBoxProperties.DefaultDescription := P.RowItemValues.Strings[0];
            for lIndexOptions := 0 to p.RowItemValues.Count - 1 do
            begin
              lcxImageComboBoxItem := lcxImageComboBoxProperties.Items.Add;
              lcxImageComboBoxItem.Description := P.RowItemValues.Strings[lIndexOptions];
              lcxImageComboBoxItem.ImageIndex := lIndexOptions;
              lcxImageComboBoxItem.Value := P.RowItemValues.Strings[lIndexOptions];
            end;
          end;
        rkCheckRow:
          begin
            lcxEditorRow := Inspector.AddChild(SuperNode, TcxEditorRow) as TcxEditorRow;
            lcxEditorRow.Properties.EditPropertiesClass := TcxCheckBoxProperties;
            lcxCheckBoxProperties := lcxEditorRow.Properties.EditProperties as TcxCheckBoxProperties;
            lcxCheckBoxProperties.ReadOnly := (not P.RowEditable) or FReadOnly;
          end;
        rkTextChoiceRow:
          begin
            lcxEditorRow := Inspector.AddChild(SuperNode, TcxEditorRow) as TcxEditorRow;
            lcxEditorRow.Properties.EditPropertiesClass := TcxComboBoxProperties;

            lcxComboBoxProperties := lcxEditorRow.Properties.EditProperties as TcxComboBoxProperties;
            lcxComboBoxProperties.Items.Assign(P.RowItemValues);
          end;
      end;
      lcxEditorRow.Properties.Hint := P.Key;
      lcxEditorRow.Properties.Caption := P.Caption;
      lcxEditorRow.Properties.ImageIndex := P.ImageIndex;
      RowList.Add(lcxEditorRow);
    end;
  finally
    CategoryRows.Free;
  end;
  Inspector.FullExpand;
  Inspector.EndUpdate;
end;

procedure TPropertyEditor.InspectorDrawValue(Sender: TObject;
  ACanvas: TcxCanvas; APainter: TcxvgPainter; AValueInfo: TcxRowValueInfo;
  var Done: Boolean);
begin
  {$Message Hint 'Not sure this is needed'}
  if FReadOnly then
    Font.Color := clGrayText
  else
    Font.Color := clWindowText;
end;

procedure TPropertyEditor.InspectorItemChanged(Sender: TObject;
  AOldRow: TcxCustomRow; AOldCellIndex: Integer);
var
  lcxEditorRow: TcxEditorRow;
begin
  if Inspector.FocusedRow is TcxEditorRow then
  begin
    lcxEditorRow := Inspector.FocusedRow as TcxEditorRow;
    if Assigned(FOnPropertySelected) then
    begin
      FOnPropertySelected(Self, lcxEditorRow.Properties.Caption);
    end;
  end;
end;

procedure TPropertyEditor.InspectorEdited(
  Sender: TObject;
  ARowProperties: TcxCustomEditorRowProperties);
begin
  PropertyModified(Sender, ARowProperties);
end;

procedure TPropertyEditor.PropertyModified(Sender: TObject; ARowProperties: TcxCustomEditorRowProperties);
var
  lRowKey: string;
  lRowValue: string;
begin
  lRowKey := ARowProperties.Hint;
  if not VarIsNull(ARowProperties.Values[0]) then
  begin
    lRowValue := ARowProperties.Values[0];
  end;
  PropertyAdaptor.SetPropertyValue(FInspectingElements, lRowKey, lRowValue);
end;

procedure TPropertyEditor.RowButtonClick(Sender: TObject; AbsoluteIndex: Integer);
var
  lcxEditorRow: TcxEditorRow;
  lKey: string;
begin
  lcxEditorRow := Inspector.FocusedRow as TcxEditorRow;
  lKey := lcxEditorRow.Properties.Hint;
  PropertyAdaptor.PropertyButtonClicked(FInspectingElements, lKey);
end;

procedure TPropertyEditor.EnterHandler(Sender: TObject);
begin
  if Assigned(OnEnter) then OnEnter(Sender);
end;

procedure TPropertyEditor.SetEnabled(Value: Boolean);
begin
  inherited;
  Inspector.Enabled := Value;
end;

procedure TPropertyEditor.ClearInspectingElements;
begin
  FInspectingElements.Clear;
end;

procedure TPropertyEditor.AddInspectingElement(AElement: PElement);
begin
  FInspectingElements.Add(AElement);
end;

procedure TPropertyEditor.RemoveInspectingElement(AElement: PElement);
begin
  FInspectingElements.Remove(AElement);
end;

procedure TPropertyEditor.InspectElements;
begin
  CollectProperties;
  SetupRows;
  UpdateProperties;
end;

procedure TPropertyEditor.UpdateProperties;
var
  I: Integer;
  lcxEditorRow: TcxEditorRow;
  E: PElement;
  Val: string;

  function MixPropertyValue(AKey: string): string;
  var
    J: Integer;
    E: PElement;
    S: string;
  begin
    E := FInspectingElements.Items[0] as PElement;
    S := PropertyAdaptor.GetPropertyValue(E, AKey);
    for J := 1 to FInspectingElements.Count - 1 do
    begin
      E := FInspectingElements.Items[J] as PElement;
      if S <> PropertyAdaptor.GetPropertyValue(E, AKey) then
      begin
        Result := '';
        Exit;
      end;
    end;
    Result := S;
  end;

begin
  Inspector.BeginUpdate;
  // Update PropertyEditor according to single element
  if FInspectingElements.Count = 1 then
  begin
    for I := 0 to RowList.Count - 1 do
    begin
      lcxEditorRow := RowList.Items[I];
      E := FInspectingElements.Items[0] as PElement;
      Val := PropertyAdaptor.GetPropertyValue(E, lcxEditorRow.Properties.Hint);
      lcxEditorRow.Properties.Value := Val;
    end;
  end
  // Update PropertyEditor according to multiple elements
  else if FInspectingElements.Count > 1 then
  begin
    for I := 0 to RowList.Count - 1 do
    begin
      lcxEditorRow := RowList.Items[I];
      Val := MixPropertyValue(lcxEditorRow.Properties.Hint);
      lcxEditorRow.Properties.Value := Val;
    end;
  end;
  Inspector.EndUpdate;
end;

procedure TPropertyEditor.ApplyChanges;
begin
// Edits are posted immediatley in new vertical grid.
//  Inspector.PostEditor;
end;

// TPropertyEditor
////////////////////////////////////////////////////////////////////////////////

end.

