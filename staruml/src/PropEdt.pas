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
  BasicClasses, Core,
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  dxExEdtr, dxCntner, dxInspct, ImgList, ExtCtrls, FlatPanel;

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
    Inspector: TdxInspector;
    RowImageList: TImageList;
    AggregationImageList: TImageList;
    VisibilityImageList: TImageList;
    ClientPanel: TFlatPanel;
    PsedostatsImageList: TImageList;
    ActionKindImageList: TImageList;
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
    procedure InspectorCustomDraw(Sender: TdxInspectorRow; ACanvas: TCanvas; ARect: TRect; var AText: string; AFont: TFont;
      var AColor: TColor; var ADone: Boolean);
    procedure InspectorChangeNode(Sender: TObject; OldNode, Node: TdxInspectorNode);
    procedure InspectorEdited(Sender: TObject; Node: TdxInspectorNode; Row: TdxInspectorRow);
    procedure ImageRowCloseUp(Sender: TObject; var Value: string; var Accept: Boolean);
    procedure PickRowCloseUp(Sender: TObject; var Value: Variant; var Accept: Boolean);
    procedure CheckRowToggleClick(Sender: TObject; const Text: string; State: TdxCheckBoxState);
    procedure PropertyModified(Sender: TObject; Node: TdxInspectorNode; Row: TdxInspectorRow);
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
  dxInspRw;

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
  for I := FProperties.Count - 1 downto 0 do begin
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
  for I := 0 to FProperties.Count - 1 do begin
    P := FProperties.Items[I];
    if P.Key = AKey then begin
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
  if FPropertyAdaptor <> Value then begin
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
  for I := PropertyList.Count - 1 downto 0 do begin
    P := PropertyList.Items[I];
    P.Free;
  end;
  PropertyList.Clear;
end;

procedure TPropertyEditor.InitializeGUI;
begin
  Inspector.OnEdited := InspectorEdited;
  Inspector.OnEnter := EnterHandler;
  Inspector.OnChangeNode := InspectorChangeNode;
  Inspector.OnDrawValue := InspectorCustomDraw;
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
        or (IsDiffKind and P.OnlyTheSameKind) then begin
        APropertyList.Remove(P);
        P.Free;
      end;
    end;
  end;

begin
  EmptyPropertyList;
  // Inspecting single element
  if FInspectingElements.Count = 1 then begin
    PropertySpecifier.EmptyProperties;
    PropertyAdaptor.SpecifyProperties(FInspectingElements.Items[0] as PElement, PropertySpecifier);
    PropertyList.Assign(PropertySpecifier.FProperties);
    PropertySpecifier.ClearProperties;
  end
  // Inspecting multiple elements
  else if InspectingElementCount > 1 then begin
    // Setting First element
    FirstElement := FInspectingElements.Items[0] as PElement;
    PropertySpecifier.EmptyProperties;
    PropertyAdaptor.SpecifyProperties(FirstElement, PropertySpecifier);
    PropertyList.Assign(PropertySpecifier.FProperties);
    PropertySpecifier.ClearProperties;
    // Intersect properties of first element with that of consequent elements
    IsDiffKind := False;
    for I := 1 to FInspectingElements.Count - 1 do begin
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
  SuperNode, SubNode: TdxInspectorRowNode;
  CategoryRows: TStringList;

  function GetCategoryRow(Category: string): TdxInspectorRowNode;
  var
    Index: Integer;
  begin
    Index := CategoryRows.IndexOf(Category);
    if Index = -1 then begin
      Result := Inspector.AddEx(TdxInspectorTextRow);
      Result.Row.Caption := Category;
      Result.Row.IsCategory := True;
      CategoryRows.AddObject(Category, Result);
    end
    else begin
      Result := TdxInspectorRowNode(CategoryRows.Objects[Index]);
    end;
  end;

begin
  Inspector.BeginUpdate;
  ClearRows;
  CategoryRows := TStringList.Create;
  for I := 0 to PropertyList.Count - 1 do begin
    P := PropertyList.Items[I];
    SuperNode := GetCategoryRow(P.Category);
    // Row creation
    case P.RowKind of
      rkTextRow : begin
        SubNode := SuperNode.AddChildEx(TdxInspectorTextRow);
        SubNode.Row.Hint := P.Key; // put Property's Key in Row's Hint
        SubNode.Row.Caption := P.Caption;
        SubNode.Row.ReadOnly := (not P.RowEditable) or FReadOnly;
        SubNode.Row.ImageIndex := P.ImageIndex;
        RowList.Add(SubNode.Row);
      end;
      rkTextButtonRow : begin
        SubNode := SuperNode.AddChildEx(TdxInspectorTextButtonRow);
        SubNode.Row.Hint := P.Key; // put Property's Key in Row's Hint
        SubNode.Row.Caption := P.Caption;
        SubNode.Row.ReadOnly := (not P.RowEditable) or FReadOnly;
        SubNode.Row.ImageIndex := P.ImageIndex;
        (SubNode.Row as TdxInspectorTextButtonRow).OnButtonClick := RowButtonClick;
        RowList.Add(SubNode.Row);
      end;
      rkChoiceRow : begin
        SubNode := SuperNode.AddChildEx(TdxInspectorTextImageRow);
        SubNode.Row.Hint := P.Key; // put Property's Key in Row's Hint
        SubNode.Row.Caption := P.Caption;
        SubNode.Row.ReadOnly := FReadOnly;
        SubNode.Row.ImageIndex := P.ImageIndex;
        with SubNode.Row as TdxInspectorTextImageRow do begin
          ShowDescription := True;
          Values.Assign(P.RowItemValues);
          Descriptions.Assign(P.RowItemValues);
          Images := P.RowItemImages;
          ImageIndexes.Assign(P.RowItemImageIndexes);
          if not FReadOnly then
            OnCloseUp := ImageRowCloseUp;
        end;
        RowList.Add(SubNode.Row);
      end;
      rkCheckRow : begin
        SubNode := SuperNode.AddChildEx(TdxInspectorTextCheckRow);
        SubNode.Row.Hint := P.Key; // put Property's Key in Row's Hint
        SubNode.Row.Caption := P.Caption;
        SubNode.Row.ReadOnly := (not P.RowEditable) or FReadOnly;
        SubNode.Row.ImageIndex := P.ImageIndex;
        if not FReadOnly then
          (SubNode.Row as TdxInspectorTextCheckRow).OnToggleClick := CheckRowToggleClick;
        RowList.Add(SubNode.Row);
      end;
      rkTextChoiceRow: begin
        SubNode := SuperNode.AddChildEx(TdxInspectorTextPickRow);
        SubNode.Row.Hint := P.Key; // put Property's Key in Row's Hint
        SubNode.Row.Caption := P.Caption;
        SubNode.Row.ReadOnly := (not P.RowEditable) or FReadOnly;
        SubNode.Row.ImageIndex := P.ImageIndex;
        with SubNode.Row as TdxInspectorTextPickRow do begin
          Items.Assign(P.RowItemValues);
          if not FReadOnly then
            OnCloseUp := PickRowCloseUp;
        end;
        RowList.Add(SubNode.Row);
      end;
    end;
  end;
  CategoryRows.Free;
  Inspector.FullExpand;
  Inspector.EndUpdate;
end;

procedure TPropertyEditor.InspectorCustomDraw(Sender: TdxInspectorRow; ACanvas: TCanvas; ARect: TRect; var AText: string; AFont: TFont;
  var AColor: TColor; var ADone: Boolean);
begin
  if FReadOnly then
    AFont.Color := clGrayText
  else
    AFont.Color := clWindowText;
end;

procedure TPropertyEditor.InspectorChangeNode(Sender: TObject; OldNode, Node: TdxInspectorNode);
begin
  if not (Node as TdxInspectorRowNode).Row.IsCategory then
    if Assigned(FOnPropertySelected) then begin
      FOnPropertySelected(Self, (Node as TdxInspectorRowNode).Row.Caption);
    end;
end;

procedure TPropertyEditor.InspectorEdited(Sender: TObject; Node: TdxInspectorNode; Row: TdxInspectorRow);
begin
  if ((Row is TdxInspectorCheckRow) or (Row is TdxInspectorPickRow)) and (Row.ReadOnly) then
    Exit;
  PropertyModified(Sender, Node, Row);
end;

procedure TPropertyEditor.ImageRowCloseUp(Sender: TObject; var Value: string; var Accept: Boolean);
var
  Row: TdxInspectorRow;
begin
  Row := Sender as TdxInspectorRow;
  (Row as TdxInspectorTextImageRow).Text := Value;
  PropertyModified(Sender, Row.Node, Row);
end;

procedure TPropertyEditor.PickRowCloseUp(Sender: TObject; var Value: Variant; var Accept: Boolean);
var
  Row: TdxInspectorRow;
begin
  Row := Sender as TdxInspectorRow;
  (Row as TdxInspectorTextPickRow).Text := Value;
  PropertyModified(Sender, Row.Node, Row);
end;

procedure TPropertyEditor.CheckRowToggleClick(Sender: TObject; const Text: string; State: TdxCheckBoxState);
var
  Row: TdxInspectorRow;
begin
  Row := Sender as TdxInspectorRow;
  (Row as TdxInspectorTextCheckRow).Text := Text;
  PropertyModified(Sender, Row.Node, Row);
end;

procedure TPropertyEditor.PropertyModified(Sender: TObject; Node: TdxInspectorNode; Row: TdxInspectorRow);
var
  RowKey: string;
  RowValue: string;
begin
  RowKey := Row.Hint;
  RowValue := '';
  if Row is TdxInspectorTextRow then
    RowValue := (Row as TdxInspectorTextRow).Text
  else if Row is TdxInspectorTextCheckRow then
    RowValue := (Row as TdxInspectorTextCheckRow).Text
  else if Row is TdxInspectorTextPickRow then
    RowValue := (Row as TdxInspectorTextPickRow).Text
  else if Row is TdxInspectorTextButtonRow then
    RowValue := (Row as TdxInspectorTextButtonRow).Text
  else if Row is TdxInspectorTextImageRow then
    RowValue := (Row as TdxInspectorTextImageRow).Text;

  PropertyAdaptor.SetPropertyValue(FInspectingElements, RowKey, RowValue);
end;

procedure TPropertyEditor.RowButtonClick(Sender: TObject; AbsoluteIndex: Integer);
begin
  PropertyAdaptor.PropertyButtonClicked(FInspectingElements, (Sender as TdxInspectorTextButtonRow).Hint);
end;

procedure TPropertyEditor.EnterHandler(Sender: TObject);
begin
  if Assigned(OnEnter) then OnEnter(Sender);
end;

procedure TPropertyEditor.SetEnabled(Value: Boolean);
begin
  inherited;
  if Value then
    Inspector.Color := clWindow
  else
    Inspector.Color := clBtnFace;
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
  Row: TdxInspectorRow;
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
    for J := 1 to FInspectingElements.Count - 1 do begin
      E := FInspectingElements.Items[J] as PElement;
      if S <> PropertyAdaptor.GetPropertyValue(E, AKey) then begin
        Result := '';
        Exit;
      end;
    end;
    Result := S;
  end;

begin
  Inspector.BeginUpdate;
  // Update PropertyEditor according to single element
  if FInspectingElements.Count = 1 then begin
    for I := 0 to RowList.Count - 1 do begin
      Row := RowList.Items[I];
      E := FInspectingElements.Items[0] as PElement;
      Val := PropertyAdaptor.GetPropertyValue(E, Row.Hint);
      if Row is TdxInspectorTextRow then
        (Row as TdxInspectorTextRow).Text := Val
      else if Row is TdxInspectorTextCheckRow then
        (Row as TdxInspectorTextCheckRow).Text := Val
      else if Row is TdxInspectorTextPickRow then
        (Row as TdxInspectorTextPickRow).Text := Val
      else if Row is TdxInspectorTextButtonRow then
        (Row as TdxInspectorTextButtonRow).Text := Val
      else if Row is TdxInspectorTextImageRow then
        (Row as TdxInspectorTextImageRow).Text := Val;
    end;
  end
  // Update PropertyEditor according to multiple elements
  else if FInspectingElements.Count > 1 then begin
    for I := 0 to RowList.Count - 1 do begin
      Row := RowList.Items[I];
      Val := MixPropertyValue(Row.Hint);
      if Row is TdxInspectorTextRow then
        (Row as TdxInspectorTextRow).Text := Val
      else if Row is TdxInspectorTextCheckRow then
        (Row as TdxInspectorTextCheckRow).Text := Val
      else if Row is TdxInspectorTextPickRow then
        (Row as TdxInspectorTextPickRow).Text := Val
      else if Row is TdxInspectorTextButtonRow then
        (Row as TdxInspectorTextButtonRow).Text := Val
      else if Row is TdxInspectorTextImageRow then
        (Row as TdxInspectorTextImageRow).Text := Val;
    end;
  end;
  Inspector.EndUpdate;
end;

procedure TPropertyEditor.ApplyChanges;
begin
  Inspector.PostEditor;
end;

// TPropertyEditor
////////////////////////////////////////////////////////////////////////////////

end.
