unit OptionRows;

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
  OptionNodes,
  Classes,
  Controls,
  Types,
  Graphics,
  StdCtrls,
  cxVGrid,
  cxDropDownEdit,
  cxGraphics;

const
  COLOR_CUSTOM = 'Custom';

type
  // forward declaration
  POptionItemRow = class;

  // POptionItemRowChangeEvent
  POptionItemRowChangeEvent = procedure(OptionItemRow: POptionItemRow);

  // POptionItemRow
  POptionItemRow = class
  protected
    InspectorExited: Boolean;
    FInspector: TcxVerticalGrid;
    FOptionItem: POptionItem;
    FInspectorRow: TcxEditorRow;
    FParentRow: TcxCategoryRow;
    FOnOptionItemRowChange: POptionItemRowChangeEvent;
    // override this procedure to create TcxEditorRow and define event handlers of TcxEditorRow
    procedure CreateInspectorRow; virtual;
  public
    constructor Create(AInspector: TcxVerticalGrid; AOptionItem: POptionItem; ParentRow: TcxCategoryRow);
    procedure HandleValueChange; virtual;
    property InspectorRow: TcxEditorRow read FInspectorRow;
    property OptionItem: POptionItem read FOptionItem;
    property OnOptionItemRowChange: POptionItemRowChangeEvent read FOnOptionItemRowChange write FOnOptionItemRowChange;
  end;

  // PIntegerOptionItemRow
  PIntegerOptionItemRow = class(POptionItemRow)
  protected
    procedure CreateInspectorRow; override;
  public
  end;

  // PRealOptionItemRow
  PRealOptionItemRow = class(POptionItemRow)
  protected
    procedure CreateInspectorRow; override;
  end;

  // PStringOptionItemRow
  PStringOptionItemRow = class(POptionItemRow)
  protected
    procedure CreateInspectorRow; override;
  end;

  // PBooleanOptionItemRow
  PBooleanOptionItemRow = class(POptionItemRow)
  protected
    procedure CreateInspectorRow; override;
  end;

  // PTextOptionItemRow
  PTextOptionItemRow = class(POptionItemRow)
  protected
    procedure CreateInspectorRow; override;
  end;

  // PEnumerationOptionItemRow
  PEnumerationOptionItemRow = class(POptionItemRow)
  protected
    procedure CreateInspectorRow; override;
  end;

  // PFontNameOptionItemRow
  PFontNameOptionItemRow = class(POptionItemRow)
  protected
    procedure CreateInspectorRow; override;
  end;

  // PFileNameOptionItemRow
  PFileNameOptionItemRow = class(POptionItemRow)
  protected
    procedure CreateInspectorRow; override;
  end;

  // PPathNameOptionItemRow
  PPathNameOptionItemRow = class(POptionItemRow)
  protected
    procedure CreateInspectorRow; override;
  end;

  // PColorOptionItemRow
  PColorOptionItemRow = class(POptionItemRow)
  private
  protected
    procedure CreateInspectorRow; override;
  public
    procedure HandleValueChange; override;
  end;

  // PRangeOptionItemRow
  PRangeOptionItemRow = class(POptionItemRow)
  protected
    procedure CreateInspectorRow; override;
  end;

implementation

uses
  OptionMgrAux,
  PVariants,
  NLS_OPTMGR,
  Forms,
  Dialogs,
  SysUtils,
  cxTextEdit,
  cxCheckBox,
  cxMemo,
  cxButtonEdit,
  cxColorComboBox,
  cxSpinEdit,
  cxMaskEdit,
  cxImageComboBox,
  cxFontNameComboBox,
  cxShellComboBox;

////////////////////////////////////////////////////////////////////////////////
// POptionItemRow

constructor POptionItemRow.Create(AInspector: TcxVerticalGrid; AOptionItem: POptionItem; ParentRow: TcxCategoryRow);
begin
  FInspector := AInspector;
  FOptionItem := AOptionItem;
  FParentRow := ParentRow;
  CreateInspectorRow;
end;

procedure POptionItemRow.HandleValueChange;
begin
  // OnEdited, OnExit and OnChangeNode event handler call this procedure
  OptionItem.Value := InspectorRow.Properties.Value;
  if Assigned(FOnOptionItemRowChange) then
    FOnOptionItemRowChange(Self);
end;

procedure POptionItemRow.CreateInspectorRow;
begin
  fInspectorRow := fInspector.AddChild(FParentRow, TcxEditorRow) as TcxEditorRow;
  fInspectorRow.Properties.Caption := OptionItem.Caption;
  fInspectorRow.Properties.Value := OptionItem.Value;
end;

// POptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PIntegerOptionItemRow

procedure PIntegerOptionItemRow.CreateInspectorRow;
var
  lcxMaskEditProperties: TcxMaskEditProperties;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxMaskEditProperties;
  lcxMaskEditProperties := InspectorRow.Properties.EditProperties as TcxMaskEditProperties;
  lcxMaskEditProperties.MaskKind := emkRegExpr;
  lcxMaskEditProperties.EditMask := '\d+';
end;

// PIntegerOptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PRealOptionItemRow

procedure PRealOptionItemRow.CreateInspectorRow;
var
  lcxMaskEditProperties: TcxMaskEditProperties;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxMaskEditProperties;
  lcxMaskEditProperties := InspectorRow.Properties.EditProperties as TcxMaskEditProperties;
  lcxMaskEditProperties.MaskKind := emkRegExpr;
  if DecimalSeparator = '.' then
  begin
    lcxMaskEditProperties.EditMask := '\d*\.?\d{0,10}'; //Allows commas as DecimalSeparator doesn't require a DecimalSeparator
  end
  else if DecimalSeparator = ',' then
  begin
    lcxMaskEditProperties.EditMask := '\d*,?\d{0,10}'; //Allows commas as DecimalSeparator doesn't require a DecimalSeparator
  end;

//  lcxMaskEditProperties.EditMask := '\d*\.\d{0,10}';

end;

// PRealOptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PStringOptionItemRow

procedure PStringOptionItemRow.CreateInspectorRow;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxTextEditProperties;
end;

// PStringOptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PBooleanOptionItemRow

procedure PBooleanOptionItemRow.CreateInspectorRow;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxCheckBoxProperties;
end;

// PBooleanOptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PTextOptionItemRow

procedure PTextOptionItemRow.CreateInspectorRow;
var
  lcxMemoProperties: TcxMemoProperties;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxMemoProperties;
  lcxMemoProperties := InspectorRow.Properties.EditProperties as TcxMemoProperties;
  lcxMemoProperties.WantReturns := True;
  lcxMemoProperties.WantTabs := True;
  lcxMemoProperties.ScrollBars := ssBoth;
  lcxMemoProperties.VisibleLineCount := 4;
end;

// PTextOptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PEnumerationOptionItemRow

procedure PEnumerationOptionItemRow.CreateInspectorRow;
var
  lEnumerationOptionItem: PEnumerationOptionItem;
  I: Integer;
  lcxImageComboBoxProperties: TcxImageComboBoxProperties;
  lcxImageComboBoxItem: TcxImageComboBoxItem;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxImageComboBoxProperties;
  lcxImageComboBoxProperties := InspectorRow.Properties.EditProperties as TcxImageComboBoxProperties;
  lEnumerationOptionItem := OptionItem as PEnumerationOptionItem;
  for I := 0 to lEnumerationOptionItem.EnumerationItemCount - 1 do
  begin
    lcxImageComboBoxItem := lcxImageComboBoxProperties.Items.Add;
    lcxImageComboBoxItem.Value := I;
    lcxImageComboBoxItem.Description := lEnumerationOptionItem.EnumerationItems[I];
  end;
  lcxImageComboBoxProperties.DropDownListStyle := lsFixedList;
  lcxImageComboBoxProperties.ShowDescriptions := True;
end;

// PEnumerationOptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PFontNameOptionItemRow

procedure PFontNameOptionItemRow.CreateInspectorRow;
var
  lcxComboBoxProperties: TcxComboBoxProperties;
  lcxFontNameComboBoxProperties: TcxFontNameComboBoxProperties;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxFontNameComboBoxProperties;
  lcxFontNameComboBoxProperties := InspectorRow.Properties.EditProperties as TcxFontNameComboBoxProperties;
  lcxFontNameComboBoxProperties.MaxMRUFonts := 5;
  lcxFontNameComboBoxProperties.FontPreview.Visible := True;
  lcxFontNameComboBoxProperties.FontPreview.PreviewType := cxfpFontName;
  lcxFontNameComboBoxProperties.FontPreview.ShowButtons := False;
end;

// PFontNameOptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PFileNameOptionItemRow

procedure PFileNameOptionItemRow.CreateInspectorRow;
var
  lcxShellComboBoxProperties: TcxShellComboBoxProperties;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxShellComboBoxProperties;
  lcxShellComboBoxProperties := InspectorRow.Properties.EditProperties as TcxShellComboBoxProperties;
  lcxShellComboBoxProperties.ShowFullPath := sfpAlways;
  lcxShellComboBoxProperties.ViewOptions := [scvoShowFiles];
end;

// PFileNameOptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PPathNameOptionItemRow

procedure PPathNameOptionItemRow.CreateInspectorRow;
var
  lcxShellComboBoxProperties: TcxShellComboBoxProperties;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxShellComboBoxProperties;
  lcxShellComboBoxProperties := InspectorRow.Properties.EditProperties as TcxShellComboBoxProperties;
  lcxShellComboBoxProperties.ShowFullPath := sfpAlways;
end;

// PPathNameOptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PColorOptionItemRow

procedure PColorOptionItemRow.HandleValueChange;
var
  lColor : TColor;
begin
  lColor := InspectorRow.Properties.Value;
  OptionItem.Value := ColorToStr(lColor);
  if Assigned(FOnOptionItemRowChange) then
  begin
    FOnOptionItemRowChange(Self);
  end;
end;

procedure PColorOptionItemRow.CreateInspectorRow;
var
  lcxColorComboBoxProperties: TcxColorComboBoxProperties;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxColorComboBoxProperties;
  lcxColorComboBoxProperties := InspectorRow.Properties.EditProperties as TcxColorComboBoxProperties;
  InspectorRow.Properties.Value := StringToColor(OptionItem.Value);
  lcxColorComboBoxProperties.AllowSelectColor := True;
  lcxColorComboBoxProperties.ColorValueFormat := cxcvHexadecimal;
end;

// PColorOptionItemRow
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PRangeOptionItemRow

procedure PRangeOptionItemRow.CreateInspectorRow;
var
  lcxSpinEditProperties: TcxSpinEditProperties;
  lRangeOptionItem: PRangeOptionItem;
begin
  inherited;
  InspectorRow.Properties.EditPropertiesClass := TcxSpinEditProperties;
  lcxSpinEditProperties := InspectorRow.Properties.EditProperties as TcxSpinEditProperties;
  lRangeOptionItem := OptionItem as PRangeOptionItem;
  lcxSpinEditProperties.MinValue := lRangeOptionItem.MinValue;
  lcxSpinEditProperties.MaxValue := lRangeOptionItem.MaxValue;
  lcxSpinEditProperties.Increment := lRangeOptionItem.Step;
end;

// PRangeOptionItemRow
////////////////////////////////////////////////////////////////////////////////

end.

