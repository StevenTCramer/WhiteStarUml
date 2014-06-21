unit InteractionMgr;

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
  BasicClasses, Core, ExtCore, UMLModels, UMLViews, Handlers, MainFrm,
  Classes, Windows, Graphics, SysUtils, dxBar, dxNavBar, dxNavBarCollns, dxNavBarBase;

type
  // Events
  PModelAddingEvent = procedure(Sender: TObject; ModelKind: string; Argument: Integer) of object;
  PDiagramAddingEvent = procedure(Sender: TObject; DiagramKind: string) of object;
  PElementCreatingEvent = procedure(Sender: TObject; ElementKind: string; Argument: Integer; X1, Y1, X2, Y2: Integer) of object;
  PExtModelAddingEvent = procedure(Sender: TObject; ProfileName: string; ModelPrototypeName: string) of object;
  PExtDiagramAddingEvent = procedure(Sender: TObject; ProfileName: string; DiagramTypeName: string) of object;
  PExtElementCreatingEvent = procedure(Sender: TObject; ProfileName: string; ElementPrototypeName: string; X1, Y1, X2, Y2: Integer) of object;

  // PPaletteItemInteraction
  PPaletteItemInteraction = class
  private
    FHanderName: string;
    FNavBarItem: TdxNavBarItem;
  public
    property HanderName: string read FHanderName write FHanderName;
    property NavBarItem: TdxNavBarItem read FNavBarItem write FNavBarItem;
  end;

  // PPredefinedPaletteItemInteraction
  PPredefinedPaletteItemInteraction = class(PPaletteItemInteraction)
  private
    FElementKind: string;
    FArgument: Integer;
  public
    property ElementKind: string read FElementKind write FElementKind;
    property Argument: Integer read FArgument write FArgument;
  end;

  // PExtendedPaletteItemInteraction
  PExtendedPaletteItemInteraction = class(PPaletteItemInteraction)
  private
    FElementPrototype: PElementPrototype;
  public
    property ElementPrototype: PElementPrototype read FElementPrototype write FElementPrototype;
  end;

  // PPaletteInteraction
  PPaletteInteraction = class
  private
    FName: string;
    FNavBarGroup: TdxNavBarGroup;
  public
    property Name: string read FName write FName;
    property NavBarGroup: TdxNavBarGroup read FNavBarGroup write FNavBarGroup;
  end;

  // PPredefinedPaletteInteraction
  PPredefinedPaletteInteraction = class(PPaletteInteraction);

  // PExtendedPaletteInteraction
  PExtendedPaletteInteraction = class(PPaletteInteraction)
  private
    FPalette: PPalette;
  public
    property Palette: PPalette read FPalette write FPalette;
  end;

  // PDiagramMenuInteraction
  PDiagramMenuInteraction = class
  private
    FMenuButton: TdxBarButton;
    FAvailablePalettes: TStringList;
    function GetAvailablePaletteCount: Integer;
    function GetAvailablePalette(Index: Integer): string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddAvailablePalette(Value: string);
    procedure RemoveAvailablePalette(Value: string);
    property MenuButton: TdxBarButton read FMenuButton write FMenuButton;
    property AvailablePaletteCount: Integer read GetAvailablePaletteCount;
    property AvailablePalettes[Index: Integer]: string read GetAvailablePalette;
  end;

  // PPredefinedDiagramMenuInteraction
  PPredefinedDiagramMenuInteraction = class(PDiagramMenuInteraction)
  private
    FDiagramKind: string;
  public
    property DiagramKind: string read FDiagramKind write FDiagramKind;
  end;

  // PExtendedDiagramMenuInteraction
  PExtendedDiagramMenuInteraction = class(PDiagramMenuInteraction)
  private
    FDiagramType: PDiagramType;
  public
    property DiagramType: PDiagramType read FDiagramType write FDiagramType;
  end;

  // PModelMenuInteraction
  PModelMenuInteraction = class
  private
    FMenuButton: TdxBarButton;
  public
    property MenuButton: TdxBarButton read FMenuButton write FMenuButton;
  end;

  // PPredefinedModelMenuInteraction
  PPredefinedModelMenuInteraction = class(PModelMenuInteraction)
  private
    FModelKind: string;
    FArgument: Integer;
  public
    property ModelKind: string read FModelKind write FModelKind;
    property Argument: Integer read FArgument write FArgument;
  end;

  // PExtendedModelMenuInteraction
  PExtendedModelMenuInteraction = class(PModelMenuInteraction)
  private
    FModelPrototype: PModelPrototype;
    FBaseMenuButton: TdxBarButton;
  public
    function IsOneOfContainer(Model: PModel): Boolean;
    property ModelPrototype: PModelPrototype read FModelPrototype write FModelPrototype;
    property BaseMenuButton: TdxBarButton read FBaseMenuButton write FBaseMenuButton;
  end;

  // PInteractionManager
  PInteractionManager = class
  private
    FPaletteItemInteractions: TList;
    FPaletteInteractions: TList;
    FDiagramMenuInteractions: TList;
    FModelMenuInteractions: TList;
    HandlerLocked: Boolean;
    FOnModelAdding: PModelAddingEvent;
    FOnDiagramAdding: PDiagramAddingEvent;
    FOnElementCreating: PElementCreatingEvent;
    FOnExtModelAdding: PExtModelAddingEvent;
    FOnExtDiagramAdding: PExtDiagramAddingEvent;
    FOnExtElementCreating: PExtElementCreatingEvent;
    { getter / setter }
    function GetPaletteItemInteractionCount: Integer;
    function GetPaletteItemInteraction(Index: Integer): PPaletteItemInteraction;
    function GetPaletteInteractionCount: Integer;
    function GetPaletteInteraction(Index: Integer): PPaletteInteraction;
    function GetDiagramMenuInteractionCount: Integer;
    function GetDiagramMenuInteraction(Index: Integer): PDiagramMenuInteraction;
    function GetModelMenuInteractionCount: Integer;
    function GetModelMenuInteraction(Index: Integer): PModelMenuInteraction;
    { event handlers }
    procedure MainFormHandlingButtonClicked(Sender: TObject);
    procedure MainFormModelAddMenuClicked(Sender: TObject);
    procedure MainFormDiagramAddMenuClicked(Sender: TObject);
    procedure MainFormElementCreatingHandler(Sender: TObject; HandlerName: string; X1, Y1, X2, Y2: Integer);
    procedure MainFormPaletteChanged(Sender: TObject);
    procedure MainFormPaletteNavBarCustomDrawLink(Sender: TObject; ACanvas: TCanvas; AViewInfo: TdxNavBarLinkViewInfo; var AHandled: Boolean);
    { finding methods }
    function FindPaletteItemInteraction(NavBarItem: TdxNavBarItem): PPaletteItemInteraction; overload;
    function FindModelMenuInteraction(MenuButton: TdxBarButton): PModelMenuInteraction; overload;
    function FindDiagramMenuInteraction(MenuButton: TdxBarButton): PDiagramMenuInteraction; overload;
    function FindPaletteInteraction(Name: string): PPaletteInteraction;
    function FindPaletteItemInteraction(HandlerName: string): PPaletteItemInteraction; overload;
    function FindPredefinedDiagramMenuInteraction(DiagramKind: string): PPredefinedDiagramMenuInteraction;
    function FindPredefinedModelMenuInteraction(ModelKind: string): PPredefinedModelMenuInteraction;
    function FindPredefinedPaletteItemInteraction(ElementKind: string): PPredefinedPaletteItemInteraction;
    function FindExtendedPaletteInteraction(Palette: PPalette): PExtendedPaletteInteraction;
    function FindExtendedPaletteItemInteraction(Profile: PProfile; ElementPrototypeName: string): PExtendedPaletteItemInteraction;
    function FindExtendedDiagramMenuInteraction(DiagramTypeName: string): PExtendedDiagramMenuInteraction;
    { predefined interaction adding methods }
    procedure AddPredefinedDiagramMenuInteraction(DiagramKind: string; MenuButton: TdxBarButton; AvailablePalettes: array of string);
    procedure AddPredefinedModelMenuInteraction(ModelKind: string; Argument: Integer; MenuButton: TdxBarButton);
    procedure AddPredefinedPaletteInteraction(Name: string; NavBarGroup: TdxNavBarGroup);
    procedure AddPredefinedPaletteItemInteraction(ElementKind: string; Argument: Integer; HandlerName: string; NavBarItem: TdxNavBarItem);
    { extended interaction adding methods }
    procedure AddExtDiagramMenuInteraction(ADiagramType: PDiagramType; IsFirst: Boolean = False);
    procedure AddExtModelMenuInteraction(AModelPrototype: PModelPrototype);
    procedure AddExtPaletteInteraction(APalette: PPalette);
    procedure AddExtPaletteItemInteraction(AElementPrototype: PElementPrototype);
    procedure CreatePaletteItemLinks(APalette: PPalette);
    { interaction building methods }
    procedure AddPredefinedCreateHandlers;
    procedure BuildPredefinedInteractions;
    procedure BuildExtendedInteractions;
    procedure AddAllProfileElementIcons;
    { miscellonous }
    function GetDiagramKindName(Diagram: PUMLDiagram): string;
    function GetContainerMenuBarGroup(Button: TdxBarButton): TdxBarGroup;
  public
    constructor Create;
    destructor Destroy; override;
    procedure BuildInteractions;
    procedure AcquireAvailableNavBarGroups(Diagram: PUMLDiagram; NavBarGroups: TList);
    procedure SetExtMenuButtonsState(Owner: PModel);
    procedure ChangePaletteVisibility(Diagram: PUMLDiagram);
    property PaletteItemInteractionCount: Integer read GetPaletteItemInteractionCount;
    property PaletteItemInteractions[Index: Integer]: PPaletteItemInteraction read GetPaletteItemInteraction;
    property PaletteInteractionCount: Integer read GetPaletteInteractionCount;
    property PaletteInteractions[Index: Integer]: PPaletteInteraction read GetPaletteInteraction;
    property DiagramMenuInteractionCount: Integer read GetDiagramMenuInteractionCount;
    property DiagramMenuInteractions[Index: Integer]: PDiagramMenuInteraction read GetDiagramMenuInteraction;
    property ModelMenuInteractionCount: Integer read GetModelMenuInteractionCount;
    property ModelMenuInteractions[Index: Integer]: PModelMenuInteraction read GetModelMenuInteraction;
    property OnModelAdding: PModelAddingEvent read FOnModelAdding write FOnModelAdding;
    property OnDiagramAdding: PDiagramAddingEvent read FOnDiagramAdding write FOnDiagramAdding;
    property OnElementCreating: PElementCreatingEvent read FOnElementCreating write FOnElementCreating;
    property OnExtModelAdding: PExtModelAddingEvent read FOnExtModelAdding write FOnExtModelAdding;
    property OnExtDiagramAdding: PExtDiagramAddingEvent read FOnExtDiagramAdding write FOnExtDiagramAdding;
    property OnExtElementCreating: PExtElementCreatingEvent read FOnExtElementCreating write FOnExtElementCreating;
  end;

  function DragTypeToSkeletonPaintKind(Value: PDragTypeKind): PSkeletonPaintingKind;

var
  InteractionManager: PInteractionManager;

implementation

uses
  UMLFacto,
  Math, CommCtrl, ImgList;

const
  POSTFIX_HANDLER = 'Handler';

////////////////////////////////////////////////////////////////////////////////
// PDiagramMenuInteraction

constructor PDiagramMenuInteraction.Create;
begin
  FAvailablePalettes := TStringList.Create;
end;

destructor PDiagramMenuInteraction.Destroy;
begin
  FAvailablePalettes.Free;
  inherited;
end;

function PDiagramMenuInteraction.GetAvailablePaletteCount: Integer;
begin
  Result := FAvailablePalettes.Count;
end;

function PDiagramMenuInteraction.GetAvailablePalette(Index: Integer): string;
begin
  Result := FAvailablePalettes[Index];
end;

procedure PDiagramMenuInteraction.AddAvailablePalette(Value: string);
begin
  FAvailablePalettes.Add(Value);
end;

procedure PDiagramMenuInteraction.RemoveAvailablePalette(Value: string);
begin
  FAvailablePalettes.Delete(FAvailablePalettes.IndexOf(Value));
end;

// PDiagramMenuInteraction
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PExtendedModelMenuInteraction

function PExtendedModelMenuInteraction.IsOneOfContainer(Model: PModel): Boolean;
var
  EM: PExtensibleModel;
  I: Integer;
begin
  // PRECONDITIONS
  Assert(FModelPrototype <> nil);
  // PRECONDITIONS
  Result := False;
  for I := 0 to FModelPrototype.ContainerModelCount - 1 do begin
    if FModelPrototype.ContainerModelStereotypes[I] = '' then begin
      if Model.MetaClass.IsKindOf(FModelPrototype.ContainerModels[I]) then begin
        Result := True;
        Exit;
      end;
    end
    else begin
      if Model is PExtensibleModel then begin
        EM := Model as PExtensibleModel;
        if Model.MetaClass.IsKindOf(FModelPrototype.ContainerModels[I]) and (EM.StereotypeName = FModelPrototype.ContainerModelStereotypes[I]) then begin
          Result := True;
          Exit;
        end;
      end;
    end;
  end;
end;

// PModelMenuInteraction
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// PInteractionManager

constructor PInteractionManager.Create;
begin
  FPaletteItemInteractions := TList.Create;
  FPaletteInteractions := TList.Create;
  FDiagramMenuInteractions := TList.Create;
  FModelMenuInteractions := TList.Create;
  MainForm.OnModelAddMenuClicked := MainFormModelAddMenuClicked;
  MainForm.OnModelAddDiagramMenuClicked := MainFormDiagramAddMenuClicked;
  MainForm.OnElementCreating := MainFormElementCreatingHandler;
  MainForm.OnHandlerButtonClicked := MainFormHandlingButtonClicked;
  MainForm.OnPaletteChanged := MainFormPaletteChanged;
  MainForm.OnPaletteNavBarCustomDrawLink := MainFormPaletteNavBarCustomDrawLink;
  HandlerLocked := False;
end;

destructor PInteractionManager.Destroy;
var
  I: Integer;
begin
  for I := PaletteItemInteractionCount - 1 downto 0 do
    PaletteItemInteractions[I].Free;
  for I := PaletteInteractionCount - 1 downto 0 do
    PaletteInteractions[I].Free;
  for I := DiagramMenuInteractionCount - 1 downto 0 do
    DiagramMenuInteractions[I].Free;
  for I := ModelMenuInteractionCount - 1 downto 0 do
    ModelMenuInteractions[I].Free;
  FPaletteItemInteractions.Free;
  FPaletteInteractions.Free;
  FDiagramMenuInteractions.Free;
  FModelMenuInteractions.Free;
  inherited;
end;

function PInteractionManager.GetPaletteItemInteractionCount: Integer;
begin
  Result := FPaletteItemInteractions.Count;
end;

function PInteractionManager.GetPaletteItemInteraction(Index: Integer): PPaletteItemInteraction;
begin
  Result := FPaletteItemInteractions[Index];
end;

function PInteractionManager.GetPaletteInteractionCount: Integer;
begin
  Result := FPaletteInteractions.Count;
end;

function PInteractionManager.GetPaletteInteraction(Index: Integer): PPaletteInteraction;
begin
  Result := FPaletteInteractions[Index];
end;

function PInteractionManager.GetDiagramMenuInteractionCount: Integer;
begin
  Result := FDiagramMenuInteractions.Count;
end;

function PInteractionManager.GetDiagramMenuInteraction(Index: Integer): PDiagramMenuInteraction;
begin
  Result := FDiagramMenuInteractions[Index];
end;

function PInteractionManager.GetModelMenuInteractionCount: Integer;
begin
  Result := FModelMenuInteractions.Count;
end;

function PInteractionManager.GetModelMenuInteraction(Index: Integer): PModelMenuInteraction;
begin
  Result := FModelMenuInteractions[Index];
end;

procedure PInteractionManager.MainFormHandlingButtonClicked(Sender: TObject);
var
  PalItemInteraction: PPaletteItemInteraction;
begin
  // PRECONDITIONS
  Assert(Sender is TdxNavBarItem);
  // PRECONDITIONS
  if Sender = MainForm.SelectNavBarItem then begin
    HandlerLocked := False;
    MainForm.ActivateSelectHandler;
  end
  else begin
    PalItemInteraction := FindPaletteItemInteraction(Sender as TdxNavBarItem);
    // ASSERTIONS
    Assert(PalItemInteraction <> nil);
    // ASSERTIONS
    if PalItemInteraction.HanderName = MainForm.ActiveHandlerName then
      HandlerLocked := True
    else begin
      MainForm.ActivateHandler(PalItemInteraction.HanderName);
      HandlerLocked := False;
    end;
    // call some mainform service (change menu state)
  end;    
end;

procedure PInteractionManager.MainFormModelAddMenuClicked(Sender: TObject);
var
  MI: PModelMenuInteraction;
  PredefMI: PPredefinedModelMenuInteraction;
  ExtMI: PExtendedModelMenuInteraction;
begin
  // PRECONDITIONS
  Assert(Sender is TdxBarButton);
  // PRECONDITIONS
  MI := FindModelMenuInteraction(Sender as TdxBarButton);
  // ASSERTIONS
  Assert(MI <> nil);
  // ASSERTIONS
  if MI is PPredefinedModelMenuInteraction then begin
    PredefMI := MI as PPredefinedModelMenuInteraction;
    if Assigned(FOnModelAdding) then
      FOnModelAdding(Self, PredefMI.ModelKind, PredefMI.Argument);
  end
  else if MI is PExtendedModelMenuInteraction then begin
    ExtMI := MI as PExtendedModelMenuInteraction;
    if Assigned(FOnExtModelAdding) then
      FOnExtModelAdding(Self, ExtMI.ModelPrototype.Profile.Name, ExtMI.ModelPrototype.Name);
  end;
end;

procedure PInteractionManager.MainFormDiagramAddMenuClicked(Sender: TObject);
var
  DI: PDiagramMenuInteraction;
  PredefDI: PPredefinedDiagramMenuInteraction;
  ExtDI: PExtendedDiagramMenuInteraction;
begin
  // PRECONDITIONS
  Assert(Sender is TdxBarButton);
  // PRECONDITIONS
  DI := FindDiagramMenuInteraction(Sender as TdxBarButton);
  // ASSERTIONS
  Assert(DI <> nil);
  // ASSERTIONS
  if DI is PPredefinedDiagramMenuInteraction then begin
    PredefDI := DI as PPredefinedDiagramMenuInteraction;
    if Assigned(FOnDiagramAdding) then
      FOnDiagramAdding(Self, PredefDI.DiagramKind);
  end
  else if DI is PExtendedDiagramMenuInteraction then begin
    ExtDI := DI as PExtendedDiagramMenuInteraction;
    if Assigned(FOnExtDiagramAdding) then
      FOnExtDiagramAdding(Self, ExtDI.DiagramType.Profile.Name, ExtDI.DiagramType.Name);
  end;
end;

procedure PInteractionManager.MainFormElementCreatingHandler(Sender: TObject; HandlerName: string; X1, Y1, X2, Y2: Integer);
var
  PI: PPaletteItemInteraction;
  PredefPI: PPredefinedPaletteItemInteraction;
  ExtPI: PExtendedPaletteItemInteraction;
begin
  PI := FindPaletteItemInteraction(HandlerName);
  // ASSERTIONS
  Assert(PI <> nil);
  // ASSERTIONS
  if PI is PPredefinedPaletteItemInteraction then begin
    PredefPI := PI as PPredefinedPaletteItemInteraction;
    if Assigned(FOnElementCreating) then
      FOnElementCreating(Self, PredefPI.ElementKind, PredefPI.Argument, X1, Y1, X2, Y2);
  end
  else if PI is PExtendedPaletteItemInteraction then begin
    ExtPI := PI as PExtendedPaletteItemInteraction;
    if Assigned(FOnExtElementCreating) then
      FOnExtElementCreating(Self, ExtPI.ElementPrototype.Profile.Name, ExtPI.ElementPrototype.Name, X1, Y1, X2, Y2);
  end;
  if not HandlerLocked then begin
    HandlerLocked := False;
    MainForm.ActivateSelectHandler;
  end;
end;

procedure PInteractionManager.MainFormPaletteChanged(Sender: TObject);
begin
  HandlerLocked := False;
  MainForm.ActivateSelectHandler;
end;

procedure PInteractionManager.MainFormPaletteNavBarCustomDrawLink(Sender: TObject; ACanvas: TCanvas; AViewInfo: TdxNavBarLinkViewInfo; var AHandled: Boolean);

  function GetDentedColor(C: TColor): TColor;
  var
    RGB: Integer;
    R, G, B: Integer;
  begin
    RGB := GetSysColor(COLOR_BTNFACE);
    R := Min((RGB div $010000) mod $100 + 21, 255);
    G := Min((RGB div $000100) mod $100 + 21, 255);
    B := Min(RGB mod $100 + 21, 255);
    Result := R * $010000 + G * $000100 + B;
  end;

  function GetRGBColor(Value: TColor): DWORD;
  begin
    Result := ColorToRGB(Value);
    case Result of
      clNone: Result := CLR_NONE;
      clDefault: Result := CLR_DEFAULT;
    end;
  end;

const
  DrawingStyles: array[TDrawingStyle] of Longint = (ILD_FOCUS,
    ILD_SELECTED, ILD_NORMAL, ILD_TRANSPARENT);
  Images: array[TImageType] of Longint = (0, ILD_MASK);

var
  LinkRect, CaptionRect, R: TRect;
  UpperLeftColor, LowerRightColor, FlatColor: TColor;
  Bitmap: TBitmap;
begin
  if (sSelected in AViewInfo.State) or (sPressed in AViewInfo.State) or (sHotTracked in AViewInfo.State) then begin
    R := AViewInfo.Rect;
    LinkRect := Rect(R.Left, R.Top + 1, R.Right, R.Bottom - 1);
    // determine colors
    FlatColor := clBtnFace;
    UpperLeftColor := clBtnHighlight;
    LowerRightColor := clBtnShadow;
    if AViewInfo.Link.IsSelected and (sHotTracked in AViewInfo.State) then begin
      UpperLeftColor := clBtnShadow;
      LowerRightColor := clBtnHighlight;
    end
    else if (sSelected in AViewInfo.State) or (sPressed in AViewInfo.State) then begin
      UpperLeftColor := clBtnShadow;
      LowerRightColor := clBtnHighlight;
      FlatColor := GetDentedColor(clBtnFace);
    end;
    // draw button
    ACanvas.Pen.Color := FlatColor;
    ACanvas.Brush.Color := FlatColor;
    ACanvas.Rectangle(LinkRect);
    ACanvas.Pen.Color := UpperLeftColor;
    ACanvas.MoveTo(LinkRect.Left, LinkRect.Bottom - 1);
    ACanvas.LineTo(LinkRect.Left, LinkRect.Top);
    ACanvas.LineTo(LinkRect.Right - 1, LinkRect.Top);
    ACanvas.Pen.Color := LowerRightColor;
    ACanvas.MoveTo(LinkRect.Left, LinkRect.Bottom - 1);
    ACanvas.LineTo(LinkRect.Right - 1, LinkRect.Bottom - 1);
    ACanvas.LineTo(LinkRect.Right - 1, LinkRect.Top);
    // draw button icon
    R := AViewInfo.ImageRect;
    with AViewInfo.ImageList do
    ImageList_DrawEx(Handle, AViewInfo.ImageIndex, ACanvas.Handle, R.Left, R.Top, 0, 0,
      GetRGBColor(BkColor), GetRGBColor(BlendColor), DrawingStyles[DrawingStyle] or Images[ImageType]);
    // draw caption
    CaptionRect := AViewInfo.CaptionRect;
    if HandlerLocked and (CaptionRect.Right + 16 > LinkRect.Right) then
      CaptionRect.Right := LinkRect.Right - 16;
    DrawText(ACanvas.Handle, PChar(AViewInfo.Item.Caption), Length(AViewInfo.Item.Caption), CaptionRect, AViewInfo.GetDrawEdgeFlag + DT_END_ELLIPSIS);
    // draw locking mark
    if HandlerLocked and AViewInfo.Link.IsSelected then begin
      Bitmap := TBitmap.Create;
      Bitmap.TransparentMode := tmAuto;
      Bitmap.Transparent := True;
      Bitmap.Mask(Bitmap.TransparentColor);
      AViewInfo.ImageList.GetBitmap(182, Bitmap);
      ACanvas.Draw(CaptionRect.Right + 2, CaptionRect.Top, Bitmap);
      Bitmap.Free;
    end;
    AHandled := True;
  end;
end;

function PInteractionManager.FindPaletteItemInteraction(NavBarItem: TdxNavBarItem): PPaletteItemInteraction;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to PaletteItemInteractionCount - 1 do
    if PaletteItemInteractions[I].NavBarItem = NavBarItem then begin
      Result := PaletteItemInteractions[I];
      Exit;
    end;
end;

function PInteractionManager.FindModelMenuInteraction(MenuButton: TdxBarButton): PModelMenuInteraction;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to ModelMenuInteractionCount - 1 do
    if ModelMenuInteractions[I].MenuButton = MenuButton then begin
      Result := ModelMenuInteractions[I];
      Exit;
    end;
end;

function PInteractionManager.FindDiagramMenuInteraction(MenuButton: TdxBarButton): PDiagramMenuInteraction;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to DiagramMenuInteractionCount - 1 do
    if DiagramMenuInteractions[I].MenuButton = MenuButton then begin
      Result := DiagramMenuInteractions[I];
      Exit;
    end;
end;

function PInteractionManager.FindPaletteInteraction(Name: string): PPaletteInteraction;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to PaletteInteractionCount - 1 do
    if PaletteInteractions[I].Name = Name then begin
      Result := PaletteInteractions[I];
      Exit;
    end;
end;

function PInteractionManager.FindPaletteItemInteraction(HandlerName: string): PPaletteItemInteraction;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to PaletteItemInteractionCount - 1 do
    if PaletteItemInteractions[I].HanderName = HandlerName then begin
      Result := PaletteItemInteractions[I];
      Exit;
    end;
end;

function PInteractionManager.FindPredefinedDiagramMenuInteraction(DiagramKind: string): PPredefinedDiagramMenuInteraction;
var
  DI: PPredefinedDiagramMenuInteraction;
  I: Integer;
begin
  Result := nil;
  for I := 0 to DiagramMenuInteractionCount - 1 do
    if DiagramMenuInteractions[I] is PPredefinedDiagramMenuInteraction then begin
      DI := DiagramMenuInteractions[I] as PPredefinedDiagramMenuInteraction;
      if DI.DiagramKind = DiagramKind then begin
        Result := DI;
        Exit;
      end;
    end;
end;

function PInteractionManager.FindPredefinedModelMenuInteraction(ModelKind: string): PPredefinedModelMenuInteraction;
var
  MI: PPredefinedModelMenuInteraction;
  I: Integer;
begin
  Result := nil;
  for I := 0 to ModelMenuInteractionCount - 1 do
    if ModelMenuInteractions[I] is PPredefinedModelMenuInteraction then begin
      MI := ModelMenuInteractions[I] as PPredefinedModelMenuInteraction;
      if MI.ModelKind = ModelKind then begin
        Result := MI;
        Exit;
      end;
    end;
end;

function PInteractionManager.FindPredefinedPaletteItemInteraction(ElementKind: string): PPredefinedPaletteItemInteraction;
var
  PI: PPredefinedPaletteItemInteraction;
  I: Integer;
begin
  Result := nil;
  for I := 0 to PaletteItemInteractionCount - 1 do
    if PaletteItemInteractions[I] is PPredefinedPaletteItemInteraction then begin
      PI := PaletteItemInteractions[I] as PPredefinedPaletteItemInteraction;
      if PI.ElementKind = ElementKind then begin
        Result := PI;
        Exit;
      end;
    end;
end;

function PInteractionManager.FindExtendedPaletteInteraction(Palette: PPalette): PExtendedPaletteInteraction;
var
  PI: PExtendedPaletteInteraction;
  I: Integer;
begin
  Result := nil;
  for I := 0 to PaletteInteractionCount - 1 do
    if PaletteInteractions[I] is PExtendedPaletteInteraction then begin
      PI := PaletteInteractions[I] as PExtendedPaletteInteraction;
      if PI.Palette = Palette then begin
        Result := PI;
        Exit;
      end;
    end;
end;

function PInteractionManager.FindExtendedPaletteItemInteraction(Profile: PProfile; ElementPrototypeName: string): PExtendedPaletteItemInteraction;
var
  PI: PExtendedPaletteItemInteraction;
  I: Integer;
begin
  Result := nil;
  for I := 0 to PaletteItemInteractionCount - 1 do
    if PaletteItemInteractions[I] is PExtendedPaletteItemInteraction then begin
      PI := PaletteItemInteractions[I] as PExtendedPaletteItemInteraction;
      if (PI.ElementPrototype.Profile = Profile) and (PI.ElementPrototype.Name = ElementPrototypeName) then begin
        Result := PI;
        Exit;
      end;
    end;
end;

function PInteractionManager.FindExtendedDiagramMenuInteraction(DiagramTypeName: string): PExtendedDiagramMenuInteraction;
var
  DI: PExtendedDiagramMenuInteraction;
  I: Integer;
begin
  Result := nil;
  for I := 0 to DiagramMenuInteractionCount - 1 do
    if DiagramMenuInteractions[I] is PExtendedDiagramMenuInteraction then begin
      DI := DiagramMenuInteractions[I] as PExtendedDiagramMenuInteraction;
      if DI.DiagramType.Name = DiagramTypeName then begin
        Result := DI;
        Exit;
      end;
    end;
end;

procedure PInteractionManager.AddPredefinedDiagramMenuInteraction(DiagramKind: string; MenuButton: TdxBarButton; AvailablePalettes: array of string);
var
  DI: PPredefinedDiagramMenuInteraction;
  I: Integer;
begin
  DI := PPredefinedDiagramMenuInteraction.Create;
  DI.DiagramKind := DiagramKind;
  DI.MenuButton := MenuButton;
  for I := 0 to Length(AvailablePalettes) - 1 do
    DI.AddAvailablePalette(AvailablePalettes[I]);
  FDiagramMenuInteractions.Add(DI);
end;

procedure PInteractionManager.AddPredefinedModelMenuInteraction(ModelKind: string; Argument: Integer; MenuButton: TdxBarButton);
var
  MI: PPredefinedModelMenuInteraction;
begin
  MI := PPredefinedModelMenuInteraction.Create;
  MI.ModelKind := ModelKind;
  MI.Argument := Argument;
  MI.MenuButton := MenuButton;
  FModelMenuInteractions.Add(MI);
end;

procedure PInteractionManager.AddPredefinedPaletteInteraction(Name: string; NavBarGroup: TdxNavBarGroup);
var
  PI: PPredefinedPaletteInteraction;
begin
  PI := PPredefinedPaletteInteraction.Create;
  PI.Name := Name;
  PI.NavBarGroup := NavBarGroup;
  FPaletteInteractions.Add(PI);
end;

procedure PInteractionManager.AddPredefinedPaletteItemInteraction(ElementKind: string; Argument: Integer; HandlerName: string; NavBarItem: TdxNavBarItem);
var
  PII: PPredefinedPaletteItemInteraction;
begin
  PII := PPredefinedPaletteItemInteraction.Create;
  PII.ElementKind := ElementKind;
  PII.Argument := Argument;
  PII.HanderName := HandlerName;
  PII.NavBarItem := NavBarItem;
  FPaletteItemInteractions.Add(PII);
end;

procedure PInteractionManager.AddExtDiagramMenuInteraction(ADiagramType: PDiagramType; IsFirst: Boolean = False);
var
  BaseDI: PPredefinedDiagramMenuInteraction;
  DI: PExtendedDiagramMenuInteraction;
  MenuButton: TdxBarButton;
  MenuLink: TdxBarItemLink;
  BarGroup: TdxBarGroup;
  I: Integer;
begin
  with MainForm do begin
    MenuButton := TdxBarButton.Create(MainForm);
    MenuButton.Caption := ADiagramType.DisplayName;
    MenuButton.ImageIndex := ADiagramType.ImageIndex;
    MenuButton.OnClick := MainFormDiagramAddMenuClicked;
    MenuLink := ModelAddDiagram.ItemLinks.Add;
    MenuLink.Item := MenuButton;
    MenuLink.BeginGroup := IsFirst;
    BaseDI := FindPredefinedDiagramMenuInteraction(ADiagramType.BaseDiagram);
    // ASSERTIONS
    Assert(BaseDI <> nil);
    // ASSERTIONS
    BarGroup := GetContainerMenuBarGroup(BaseDI.MenuButton);
    // ASSERTIONS
    Assert(BarGroup <> nil);
    // ASSERTIONS
    BarGroup.Add(MenuButton);
  end;
  DI := PExtendedDiagramMenuInteraction.Create;
  DI.DiagramType := ADiagramType;
  DI.MenuButton := MenuButton;
  for I := 0 to ADiagramType.AvailablePaletteCount - 1 do
    DI.AddAvailablePalette(ADiagramType.AvailablePalettes[I]);
  FDiagramMenuInteractions.Add(DI);
end;


procedure PInteractionManager.AddExtModelMenuInteraction(AModelPrototype: PModelPrototype);
var
  BaseMI: PPredefinedModelMenuInteraction;
  MI: PExtendedModelMenuInteraction;
  MenuButton: TdxBarButton;
  MenuLink: TdxBarItemLink;
  BarGroup: TdxBarGroup;
begin
  // PRECONDITIONS
  Assert(AModelPrototype.BaseModel <> '');
  Assert(AModelPrototype.ContainerModelCount > 0);
  // PRECONDITIONS
  with MainForm do begin
    MenuButton := TdxBarButton.Create(MainForm);
    MenuButton.Caption := AModelPrototype.DisplayName;
    MenuButton.ImageIndex := AModelPrototype.ImageIndex;
    MenuButton.OnClick := MainFormModelAddMenuClicked;
    MenuLink := ModelAdd.ItemLinks.Add;
    MenuLink.Index := 0;
    MenuLink.Item := MenuButton;
    BaseMI := FindPredefinedModelMenuInteraction(AModelPrototype.BaseModel);
    // ASSERTIONS
    Assert(BaseMI <> nil);
    // ASSERTIONS
    BarGroup := GetContainerMenuBarGroup(BaseMI.MenuButton);
    BarGroup.Add(MenuButton);
  end;
  MI := PExtendedModelMenuInteraction.Create;
  MI.ModelPrototype := AModelPrototype;
  MI.MenuButton := MenuButton;
  MI.BaseMenuButton := BaseMI.MenuButton;
  FModelMenuInteractions.Add(MI);
end;

procedure PInteractionManager.AddExtPaletteInteraction(APalette: PPalette);
var
  PI: PExtendedPaletteInteraction;
  NavBarGroup: TdxNavBarGroup;
begin
  NavBarGroup := MainForm.PaletteNavBar.Groups.Add;
  NavBarGroup.Caption := APalette.DisplayName;
  NavBarGroup.Visible := True;
  NavBarGroup.CreateLink(MainForm.SelectNavBarItem);
  PI := PExtendedPaletteInteraction.Create;
  PI.Name := APalette.Name;
  PI.NavBarGroup := NavBarGroup;
  PI.Palette := APalette;
  FPaletteInteractions.Add(PI);
end;

procedure PInteractionManager.AddExtPaletteItemInteraction(AElementPrototype: PElementPrototype);
var
  PII: PExtendedPaletteItemInteraction;
  NavBarItem: TdxNavBarItem;
  HandlerName: string;
begin
  HandlerName := AElementPrototype.Name + POSTFIX_HANDLER;
  MainForm.AddCreateHandler(HandlerName, [], DragTypeToSkeletonPaintKind(AElementPrototype.DragType));
  NavBarItem := MainForm.PaletteNavBar.Items.Add;
  NavBarItem.Caption := AElementPrototype.DisplayName;
  NavBarItem.SmallImageIndex := AElementPrototype.ImageIndex;
  NavBarItem.OnClick := MainFormHandlingButtonClicked;
  PII := PExtendedPaletteItemInteraction.Create;
  PII.ElementPrototype := AElementPrototype;
  PII.HanderName := HandlerName;
  PII.NavBarItem := NavBarItem;
  FPaletteItemInteractions.Add(PII);
end;

procedure PInteractionManager.CreatePaletteItemLinks(APalette: PPalette);
var
  PI: PExtendedPaletteInteraction;
  PII: PPaletteItemInteraction;
  I: Integer;
begin
  PI := FindExtendedPaletteInteraction(APalette);
  // ASSERTIONS
  Assert(PI <> nil);
  // ASSERTIONS
  for I := 0 to APalette.PaletteItemCount - 1 do begin
    PII := FindExtendedPaletteItemInteraction(APalette.Profile, APalette.PaletteItems[I]);
    if PII = nil then
      PII := FindPredefinedPaletteItemInteraction(APalette.PaletteItems[I]);
    if PII <> nil then
      PI.NavBarGroup.CreateLink(PII.NavBarItem);
  end;
end;

procedure PInteractionManager.AddPredefinedCreateHandlers;
begin
  with MainForm do begin
    AddCreateHandler('TextCreateHandler',                [],              spRect);
    AddCreateHandler('NoteCreateHandler',                [],              spRect);
    AddCreateHandler('NoteLinkCreateHandler',            [],              spLine);
    AddCreateHandler('SubsystemCreateHandler',           [],              spRect);
    AddCreateHandler('PackageCreateHandler',             [],              spRect);
    AddCreateHandler('UseCaseCreateHandler',             [],              spRect);
    AddCreateHandler('ActorCreateHandler',               [],              spRect);
    AddCreateHandler('ClassCreateHandler',               [],              spRect);
    AddCreateHandler('InterfaceCreateHandler',           [],              spRect);
    AddCreateHandler('EnumerationCreateHandler',         [],              spRect);
    AddCreateHandler('SignalCreateHandler',              [],              spRect);
    AddCreateHandler('ExceptionCreateHandler',           [],              spRect);
    AddCreateHandler('ComponentCreateHandler',           [],              spRect);
    AddCreateHandler('ComponentInstanceCreateHandler',   [],              spRect);
    AddCreateHandler('NodeCreateHandler',                [],              spRect);
    AddCreateHandler('NodeInstanceCreateHandler',        [],              spRect);
    AddCreateHandler('AssociationCreateHandler',         [],              spLine);
    AddCreateHandler('DirectedAssociationHandler',       [],              spLine);
    AddCreateHandler('AggregationHandler',               [],              spLine);
    AddCreateHandler('CompositionHandler',               [],              spLine);
    AddCreateHandler('GeneralizationCreateHandler',      [],              spLine);
    AddCreateHandler('DependencyCreateHandler',          [],              spLine);
    AddCreateHandler('RealizationCreateHandler',         [],              spLine);
    AddCreateHandler('AssociationClassCreateHandler',    [],              spLine);
    AddCreateHandler('IncludeCreateHandler',             [],              spLine);
    AddCreateHandler('ExtendCreateHandler',              [],              spLine);
    AddCreateHandler('ObjectCreateHandler',              [],              spRect);
    AddCreateHandler('ClassifierRoleCreateHandler',      [],              spRect);
    AddCreateHandler('AssociationRoleCreateHandler',     [],              spLine);
    AddCreateHandler('SelfAssociationRoleCreateHandler', [],              spLine);
    AddCreateHandler('LinkCreateHandler',                [],              spLine);
    AddCreateHandler('SelfLinkCreateHandler',            [],              spLine);
    AddCreateHandler('MessageCreateHandler',             [],              spLine);
    AddCreateHandler('SelfMessageCreateHandler',         [],              spLine);
    AddCreateHandler('ForwardMessageCreateHandler',      [],              spLine);
    AddCreateHandler('ReverseMessageCreateHandler',      [],              spLine);
    AddCreateHandler('StimulusCreateHandler',            [],              spLine);
    AddCreateHandler('SelfStimulusCreateHandler',        [],              spLine);
    AddCreateHandler('ForwardStimulusCreateHandler',     [],              spLine);
    AddCreateHandler('ReverseStimulusCreateHandler',     [],              spLine);
    AddCreateHandler('StateCreateHandler',               [PUMLStateView], spRect);
    AddCreateHandler('SubmachineStateCreateHandler',     [PUMLStateView], spRect);
    AddCreateHandler('ActivityCreateHandler',            [],              spRect);
    AddCreateHandler('SubactivityStateCreateHandler',    [],              spRect);
    AddCreateHandler('FinalStateCreateHandler',          [PUMLStateView], spRect);
    AddCreateHandler('InitialStateCreateHandler',        [PUMLStateView], spRect);
    AddCreateHandler('JunctionPointCreateHandler',       [PUMLStateView], spRect);
    AddCreateHandler('ChoicePointCreateHandler',         [PUMLStateView], spRect);
    AddCreateHandler('DeepHistoryCreateHandler',         [PUMLStateView], spRect);
    AddCreateHandler('ShallowHistoryCreateHandler',      [PUMLStateView], spRect);
    AddCreateHandler('SynchronizationCreateHandler',     [PUMLStateView], spLine);
    AddCreateHandler('DecisionCreateHandler',            [],              spRect);
    AddCreateHandler('TransitionCreateHandler',          [],              spLine);
    AddCreateHandler('SelfTransitionCreateHandler',      [],              spLine);
    AddCreateHandler('VerticalSwimlaneCreateHandler',    [],              spRect);
    AddCreateHandler('HorizontalSwimlaneCreateHandler',  [],              spRect);
    AddCreateHandler('ObjectFlowStateCreateHandler',     [PUMLStateView], spRect);
    AddCreateHandler('FlowFinalStateCreateHandler',      [PUMLStateView], spRect);
    AddCreateHandler('SystemBoundaryCreateHandler',      [],              spRect);
    AddCreateHandler('SignalAcceptStateCreateHandler',   [],              spRect);
    AddCreateHandler('SignalSendStateCreateHandler',     [],              spRect);
    AddCreateHandler('ArtifactCreateHandler',            [],              spRect);
    AddCreateHandler('PortCreateHandler',                [],              spRect);
    AddCreateHandler('PartCreateHandler',                [],              spRect);
    AddCreateHandler('ConnectorCreateHandler',           [],              spLine);
    AddCreateHandler('CombinedFragmentCreateHandler',    [],              spRect);
    AddCreateHandler('InteractionOperandCreateHandler',  [],              spRect);
    AddCreateHandler('FrameCreateHandler',               [],              spRect);
    AddCreateHandler('RectangleCreateHandler',           [],              spRect);
    AddCreateHandler('EllipseCreateHandler',             [],              spRect);
    AddCreateHandler('RoundRectCreateHandler',           [],              spRect);
    AddCreateHandler('LineCreateHandler',                [],              spLine);
    AddCreateHandler('ImageCreateHandler',               [],              spRect);
  end;
end;

procedure PInteractionManager.BuildPredefinedInteractions;
begin
  AddPredefinedCreateHandlers;
  with MainForm do begin
    { diagram menu interactions }
    AddPredefinedDiagramMenuInteraction(DK_USECASE_DIAGRAM, ModelAddDiagramUseCaseDiagram, ['UseCase']);
    AddPredefinedDiagramMenuInteraction(DK_CLASS_DIAGRAM, ModelAddDiagramClassDiagram, ['Class']);
    AddPredefinedDiagramMenuInteraction(DK_SEQUENCEROLE_DIAGRAM, ModelAddDiagramSequenceRoleDiagram, ['SequenceRole']);
    AddPredefinedDiagramMenuInteraction(DK_SEQUENCE_DIAGRAM, ModelAddDiagramSequenceDiagram, ['Sequence']);
    AddPredefinedDiagramMenuInteraction(DK_COLLABORATIONROLE_DIAGRAM, ModelAddDiagramCollaborationRoleDiagram, ['CollaborationRole']);
    AddPredefinedDiagramMenuInteraction(DK_COLLABORATION_DIAGRAM, ModelAddDiagramCollaborationDiagram, ['Collaboration']);
    AddPredefinedDiagramMenuInteraction(DK_STATECHART_DIAGRAM, ModelAddDiagramStatechartDiagram, ['Statechart']);
    AddPredefinedDiagramMenuInteraction(DK_ACTIVITY_DIAGRAM, ModelAddDiagramActivityDiagram, ['Activity']);
    AddPredefinedDiagramMenuInteraction(DK_COMPONENT_DIAGRAM, ModelAddDiagramComponentDiagram, ['Component']);
    AddPredefinedDiagramMenuInteraction(DK_DEPLOYMENT_DIAGRAM, ModelAddDiagramDeploymentDiagram, ['Deployment']);
    AddPredefinedDiagramMenuInteraction(DK_COMPOSITESTRUCTURE_DIAGRAM, ModelAddDiagramCompositeStructureDiagram, ['CompositeStructure']);
    { model menu interactions }
    AddPredefinedModelMenuInteraction(EK_MODEL, 0, ModelAddModel);
    AddPredefinedModelMenuInteraction(EK_SUBSYSTEM, 0, ModelAddSubsystem);
    AddPredefinedModelMenuInteraction(EK_PACKAGE, 0, ModelAddPackage);
    AddPredefinedModelMenuInteraction(EK_CLASS, 0, ModelAddClass);
    AddPredefinedModelMenuInteraction(EK_INTERFACE, 0, ModelAddInterface);
    AddPredefinedModelMenuInteraction(EK_USECASE, 0, ModelAddUseCase);
    AddPredefinedModelMenuInteraction(EK_ACTOR, 0, ModelAddActor);
    AddPredefinedModelMenuInteraction(EK_SIGNAL, 0, ModelAddSignal);
    AddPredefinedModelMenuInteraction(EK_EXCEPTION, 0, ModelAddException);
    AddPredefinedModelMenuInteraction(EK_OBJECT, 0, ModelAddObject);
    AddPredefinedModelMenuInteraction(EK_ENUMERATION, 0, ModelAddEnumeration);
    AddPredefinedModelMenuInteraction(EK_COMPONENT, 0, ModelAddComponent);
    AddPredefinedModelMenuInteraction(EK_COMPONENTINSTANCE, 0, ModelAddComponentInstance);
    AddPredefinedModelMenuInteraction(EK_NODE, 0, ModelAddNode);
    AddPredefinedModelMenuInteraction(EK_NODEINSTANCE, 0, ModelAddNodeInstance);
    AddPredefinedModelMenuInteraction(EK_OPERATION, 0, ModelAddOperation);
    AddPredefinedModelMenuInteraction(EK_ATTRIBUTE, 0, ModelAddAttribute);
    AddPredefinedModelMenuInteraction(EK_PARAMETER, 0, ModelAddParameter);
    AddPredefinedModelMenuInteraction(EK_TEMPLATEPARAMETER, 0, ModelAddTemplateParameter);
    AddPredefinedModelMenuInteraction(EK_ENUMERATIONLITERAL, 0, ModelAddEnumerationLiteral);
    AddPredefinedModelMenuInteraction(EK_COLLABORATION, 0, ModelAddCollaboration);
    AddPredefinedModelMenuInteraction(EK_COLLABORATIONINSTANCESET, 0, ModelAddCollaborationInstanceSet);
    AddPredefinedModelMenuInteraction(EK_CLASSIFIERROLE, 0, ModelAddClassifierRole);
    AddPredefinedModelMenuInteraction(EK_INTERACTION, 0, ModelAddInteraction);
    AddPredefinedModelMenuInteraction(EK_INTERACTIONINSTANCESET, 0, ModelAddInteractionInstanceSet);
    AddPredefinedModelMenuInteraction(EK_STATEMACHINE, 0, ModelAddStateMachine);
    AddPredefinedModelMenuInteraction(EK_ACTIVITYGRAPH, 0, ModelAddActivityGraph);
    AddPredefinedModelMenuInteraction(EK_STATE, 0, ModelAddState);
    AddPredefinedModelMenuInteraction(EK_SUBMACHINESTATE, 0, ModelAddSubmachineState);
    AddPredefinedModelMenuInteraction(EK_ACTIONSTATE, 0, ModelAddActionState);
    AddPredefinedModelMenuInteraction(EK_SUBACTIVITYSTATE, 0, ModelAddSubactivityState);
    AddPredefinedModelMenuInteraction(EK_FINALSTATE, 0, ModelAddFinalState);
    AddPredefinedModelMenuInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_INITIALSTATE, ModelAddInitialState);
    AddPredefinedModelMenuInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_DECISION, ModelAddDecision);
    AddPredefinedModelMenuInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_JUNCTIONPOINT, ModelAddJunctionPoint);
    AddPredefinedModelMenuInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_CHOICEPOINT, ModelAddChoicePoint);
    AddPredefinedModelMenuInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_SHALLOWHISTORY, ModelAddShallowHistory);
    AddPredefinedModelMenuInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_DEEPHISTORY, ModelAddDeepHistory);
    AddPredefinedModelMenuInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_SYNCHRONIZATION, ModelAddSynchronization);
    AddPredefinedModelMenuInteraction(EK_SWIMLANE, 0, ModelAddSwimlane);
    AddPredefinedModelMenuInteraction(EK_UNINTERPRETEDACTION, -1, ModelAddEffect);
    AddPredefinedModelMenuInteraction(EK_UNINTERPRETEDACTION, FA_UNINTERPRETEDACTION_ENTRY, ModelAddEntryAction);
    AddPredefinedModelMenuInteraction(EK_UNINTERPRETEDACTION, FA_UNINTERPRETEDACTION_DO, ModelAddDoAction);
    AddPredefinedModelMenuInteraction(EK_UNINTERPRETEDACTION, FA_UNINTERPRETEDACTION_EXIT, ModelAddExitAction);
    AddPredefinedModelMenuInteraction(EK_SIGNALEVENT, 0, ModelAddSignalEvent);
    AddPredefinedModelMenuInteraction(EK_CALLEVENT, 0, ModelAddCallEvent);
    AddPredefinedModelMenuInteraction(EK_TIMEEVENT, 0, ModelAddTimeEvent);
    AddPredefinedModelMenuInteraction(EK_CHANGEEVENT, 0, ModelAddChangeEvent);
    AddPredefinedModelMenuInteraction(EK_OBJECTFLOWSTATE, 0, ModelAddObjectFlowState);
    AddPredefinedModelMenuInteraction(EK_FLOWFINALSTATE, 0, ModelAddFlowFinalState);
    AddPredefinedModelMenuInteraction(EK_SIGNALACCEPTSTATE, 0, ModelAddSignalAcceptState);
    AddPredefinedModelMenuInteraction(EK_SIGNALSENDSTATE, 0, ModelAddSignalSendState);
    AddPredefinedModelMenuInteraction(EK_ARTIFACT, 0, ModelAddArtifact);
    AddPredefinedModelMenuInteraction(EK_ATTRIBUTELINK, 0, ModelAddAttributeLink);
    AddPredefinedModelMenuInteraction(EK_PORT, 0, ModelAddPort);
    AddPredefinedModelMenuInteraction(EK_EXTENSIONPOINT, 0, ModelAddExtensionPoint);
    AddPredefinedModelMenuInteraction(EK_COMBINEDFRAGMENT, 0, ModelAddCombinedFragment);
    AddPredefinedModelMenuInteraction(EK_INTERACTIONOPERAND, 0, ModelAddInteractionOperand);
    { palette interactions }
    AddPredefinedPaletteInteraction('UseCase', UseCaseDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('Class', ClassDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('SequenceRole', SequenceRoleDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('Sequence', SequenceDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('CollaborationRole', CollaborationRoleDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('Collaboration', CollaborationDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('Statechart', StatechartDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('Activity', ActivityDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('Component', ComponentDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('Deployment', DeploymentDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('CompositeStructure', CompositeStructureDiagramNavBarGroup);
    AddPredefinedPaletteInteraction('Annotation', AnnotationNavBarGroup);
    { palette item interactions }
    AddPredefinedPaletteItemInteraction(EK_TEXT, 0, 'TextCreateHandler', TextNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_NOTE, 0, 'NoteCreateHandler', NoteNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_NOTELINK, 0, 'NoteLinkCreateHandler', NoteLinkNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_SUBSYSTEM, 0, 'SubsystemCreateHandler', SubsystemNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_PACKAGE, 0, 'PackageCreateHandler', PackageNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_USECASE, 0, 'UseCaseCreateHandler', UsecaseNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ACTOR, 0, 'ActorCreateHandler', ActorNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_CLASS, 0, 'ClassCreateHandler', ClassNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_INTERFACE, 0, 'InterfaceCreateHandler', InterfaceNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ENUMERATION, 0, 'EnumerationCreateHandler', EnumerationNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_SIGNAL, 0, 'SignalCreateHandler', SignalNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_EXCEPTION, 0, 'ExceptionCreateHandler', ExceptionNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_COMPONENT, 0, 'ComponentCreateHandler', ComponentNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_COMPONENTINSTANCE, 0, 'ComponentInstanceCreateHandler', ComponentInstanceNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_NODE, 0, 'NodeCreateHandler', NodeNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_NODEINSTANCE, 0, 'NodeInstanceCreateHandler', NodeInstanceNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ASSOCIATION, 0, 'AssociationCreateHandler', AssociationNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ASSOCIATION, FA_DIRECTED_ASSOCIATION, 'DirectedAssociationHandler', DirectedAssociationNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ASSOCIATION, FA_AGGREGATION, 'AggregationHandler', AggregationNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ASSOCIATION, FA_COMPOSITION, 'CompositionHandler', CompositionNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_GENERALIZATION, 0, 'GeneralizationCreateHandler', GeneralizationNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_DEPENDENCY, 0, 'DependencyCreateHandler', DependencyNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_REALIZATION, 0, 'RealizationCreateHandler', RealizationNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ASSOCIATIONCLASS, 0, 'AssociationClassCreateHandler', AssociationClassNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_INCLUDE, 0, 'IncludeCreateHandler', IncludeNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_EXTEND, 0, 'ExtendCreateHandler', ExtendNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_OBJECT, 0, 'ObjectCreateHandler', ObjectNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_CLASSIFIERROLE, 0, 'ClassifierRoleCreateHandler', ClassifierRoleNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ASSOCIATIONROLE, 0, 'AssociationRoleCreateHandler', AssociationRoleNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ASSOCIATIONROLE, 0, 'SelfAssociationRoleCreateHandler', SelfAssociationRoleNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_LINK, 0, 'LinkCreateHandler', LinkNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_LINK, 0, 'SelfLinkCreateHandler', SelfLinkNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_MESSAGE, 0, 'MessageCreateHandler', MessageNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_MESSAGE, 0, 'ForwardMessageCreateHandler', ForwardMessageNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_MESSAGE, FA_REVERSE_MESSAGE_CALLACTION, 'ReverseMessageCreateHandler', ReverseMessageNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_MESSAGE, 0, 'SelfMessageCreateHandler', SelfMessageNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_STIMULUS, 0, 'StimulusCreateHandler', StimulusNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_STIMULUS, 0, 'ForwardStimulusCreateHandler', ForwardStimulusNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_STIMULUS, FA_REVERSE_STIMULUS_CALLACTION, 'ReverseStimulusCreateHandler', ReverseStimulusNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_STIMULUS, 0, 'SelfStimulusCreateHandler', SelfStimulusNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_STATE, 0, 'StateCreateHandler', StateNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_SUBMACHINESTATE, 0, 'SubmachineStateCreateHandler', SubmachineStateNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ACTIVITY, 0, 'ActivityCreateHandler', ActionStateNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_SUBACTIVITYSTATE, 0, 'SubactivityStateCreateHandler', SubactivityStateNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_INITIALSTATE, 'InitialStateCreateHandler', InitialStateNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_FINALSTATE, 0, 'FinalStateCreateHandler', FinalStateNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_JUNCTIONPOINT, 'JunctionPointCreateHandler', JunctionPointNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_CHOICEPOINT, 'ChoicePointCreateHandler', ChoicePointNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_SHALLOWHISTORY, 'ShallowHistoryCreateHandler', ShallowHistoryNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_DEEPHISTORY, 'DeepHistoryCreateHandler', DeepHistoryNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_SYNCHRONIZATION, 'SynchronizationCreateHandler', SynchronizationNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_PSEUDOSTATE, FA_PSEUDOSTATE_DECISION, 'DecisionCreateHandler', DecisionNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_TRANSITION, 0, 'TransitionCreateHandler', TransitionNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_TRANSITION, 0, 'SelfTransitionCreateHandler', SelfTransitionNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_SWIMLANE, FA_SWIMLANE_VERTICAL, 'VerticalSwimlaneCreateHandler', VerticalSwimlaneNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_SWIMLANE, FA_SWIMLANE_HORIZONTAL, 'HorizontalSwimlaneCreateHandler', HorizontalSwimlaneNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_OBJECTFLOWSTATE, 0, 'ObjectFlowStateCreateHandler', ObjectFlowStateNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_FLOWFINALSTATE, 0, 'FlowFinalStateCreateHandler', FlowFinalStateNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_SYSTEMBOUNDARY, 0, 'SystemBoundaryCreateHandler', SystemBoundaryNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_SIGNALACCEPTSTATE, 0, 'SignalAcceptStateCreateHandler', SignalAcceptStateNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_SIGNALSENDSTATE, 0, 'SignalSendStateCreateHandler', SignalSendStateNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ARTIFACT, 0, 'ArtifactCreateHandler', ArtifactNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_PORT, 0, 'PortCreateHandler', PortNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_PART, 0, 'PartCreateHandler', PartNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_CONNECTOR, 0, 'ConnectorCreateHandler', ConnectorNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_COMBINEDFRAGMENT, 0, 'CombinedFragmentCreateHandler', CombinedFragmentNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_INTERACTIONOPERAND, 0, 'InteractionOperandCreateHandler', InteractionOperandNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_RECTANGLE, 0, 'RectangleCreateHandler', RectangleNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ELLIPSE, 0, 'EllipseCreateHandler', EllipseNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_ROUNDRECT, 0, 'RoundRectCreateHandler', RoundRectNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_LINE, 0, 'LineCreateHandler', LineNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_IMAGE, 0, 'ImageCreateHandler', ImageNavBarItem);
    AddPredefinedPaletteItemInteraction(EK_FRAME, 0, 'FrameCreateHandler', FrameNavBarItem);
  end;
end;

procedure PInteractionManager.BuildExtendedInteractions;
var
  Profile: PProfile;
  Palette: PPalette;
  DigramMenuAdded: Boolean;
  I, J: Integer;
begin
  DigramMenuAdded := False;
  for I := 0 to ExtensionManager.AvailableProfileCount - 1 do begin
    Profile := ExtensionManager.AvailableProfiles[I];
    for J := 0 to Profile.ElementPrototypeCount - 1 do
      AddExtPaletteItemInteraction(Profile.ElementPrototypes[J]);
    for J := 0 to Profile.PaletteCount - 1 do begin
      Palette := Profile.Palettes[J];
      AddExtPaletteInteraction(Palette);
      CreatePaletteItemLinks(Palette);
    end;
    for J := 0 to Profile.DiagramTypeCount - 1 do begin
      AddExtDiagramMenuInteraction(Profile.DiagramTypes[J], not DigramMenuAdded);
      DigramMenuAdded := True;
    end;
    MainForm.ModelAdd.ItemLinks[0].BeginGroup := True;
    for J := Profile.ModelPrototypeCount - 1 downto 0 do
      if Profile.ModelPrototypes[J].ContainerModelCount > 0 then
        AddExtModelMenuInteraction(Profile.ModelPrototypes[J]);
  end;
end;

procedure PInteractionManager.AddAllProfileElementIcons;
var
  Profile: PProfile;
  DiagramType: PDiagramType;
  Stereotype: PStereotype;
  ElemPrototype: PElementPrototype;
  ModelPrototype: PModelPrototype;
  Bitmap: TBitmap;
  I, J: Integer;
begin
  for I := 0 to ExtensionManager.AvailableProfileCount - 1 do begin
    Profile := ExtensionManager.AvailableProfiles[I];
    for J := 0 to Profile.StereotypeCount - 1 do begin
      Stereotype := Profile.Stereotypes[J];
      if (Stereotype.SmallIconFile <> '') and FileExists(Stereotype.SmallIconFile)
        and (UpperCase(ExtractFileExt(Stereotype.SmallIconFile)) = FILE_EXT_BMP) then begin
        Stereotype.ImageIndex := -1;
        Bitmap := TBitmap.Create;
        try
          Bitmap.LoadFromFile(Stereotype.SmallIconFile);
          Stereotype.ImageIndex := MainForm.TotalImageList.AddMasked(Bitmap, Bitmap.TransparentColor);
        except
          Stereotype.ImageIndex := -1;
        end;
        Bitmap.Free;
      end;
    end;
    for J := 0 to Profile.DiagramTypeCount - 1 do begin
      DiagramType := Profile.DiagramTypes[J];
      if (DiagramType.IconFile <> '') and FileExists(DiagramType.IconFile)
        and (UpperCase(ExtractFileExt(DiagramType.IconFile)) = FILE_EXT_BMP) then begin
        DiagramType.ImageIndex := -1;
        Bitmap := TBitmap.Create;
        try
          Bitmap.LoadFromFile(DiagramType.IconFile);
          DiagramType.ImageIndex := MainForm.TotalImageList.AddMasked(Bitmap, Bitmap.TransparentColor);
        except
          DiagramType.ImageIndex := -1;
        end;
        Bitmap.Free;
      end;
    end;
    for J := 0 to Profile.ElementPrototypeCount - 1 do begin
      ElemPrototype := Profile.ElementPrototypes[J];
      if (ElemPrototype.IconFile <> '') and FileExists(ElemPrototype.IconFile)
        and (UpperCase(ExtractFileExt(ElemPrototype.IconFile)) = FILE_EXT_BMP) then begin
        ElemPrototype.ImageIndex := -1;
        Bitmap := TBitmap.Create;
        try
          Bitmap.LoadFromFile(ElemPrototype.IconFile);
          ElemPrototype.ImageIndex := MainForm.TotalImageList.AddMasked(Bitmap, Bitmap.TransparentColor);
        except
          ElemPrototype.ImageIndex := -1;
        end;
        Bitmap.Free;
      end;
    end;
    for J := 0 to Profile.ModelPrototypeCount - 1 do begin
      ModelPrototype := Profile.ModelPrototypes[J];
      if (ModelPrototype.IconFile <> '') and FileExists(ModelPrototype.IconFile)
        and (UpperCase(ExtractFileExt(ModelPrototype.IconFile)) = FILE_EXT_BMP) then begin
        ModelPrototype.ImageIndex := -1;
        Bitmap := TBitmap.Create;
        try
          Bitmap.LoadFromFile(ModelPrototype.IconFile);
          ModelPrototype.ImageIndex := MainForm.TotalImageList.AddMasked(Bitmap, Bitmap.TransparentColor);
        except
          ModelPrototype.ImageIndex := -1;
        end;
        Bitmap.Free;
      end;
    end;
  end;
end;

function PInteractionManager.GetDiagramKindName(Diagram: PUMLDiagram): string;
var
  S: string;
begin
  S := '';
  if Diagram.DiagramType <> '' then
    S := Diagram.DiagramType
  else if Diagram is PUMLClassDiagram then
    S := DK_CLASS_DIAGRAM
  else if Diagram is PUMLUseCaseDiagram then
    S := DK_USECASE_DIAGRAM
  else if Diagram is PUMLSequenceDiagram then
    S := DK_SEQUENCE_DIAGRAM
  else if Diagram is PUMLSequenceRoleDiagram then
    S := DK_SEQUENCEROLE_DIAGRAM
  else if Diagram is PUMLCollaborationDiagram then
    S := DK_COLLABORATION_DIAGRAM
  else if Diagram is PUMLCollaborationRoleDiagram then
    S := DK_COLLABORATIONROLE_DIAGRAM
  else if Diagram is PUMLStatechartDiagram then
    S := DK_STATECHART_DIAGRAM
  else if Diagram is PUMLActivityDiagram then
    S := DK_ACTIVITY_DIAGRAM
  else if Diagram is PUMLComponentDiagram then
    S := DK_COMPONENT_DIAGRAM
  else if Diagram is PUMLDeploymentDiagram then
    S := DK_DEPLOYMENT_DIAGRAM
  else if Diagram is PUMLCompositeStructureDiagram then
    S := DK_COMPOSITESTRUCTURE_DIAGRAM;
  // ASSERTIONS
  Assert(S <> '');
  // ASSERTIONS
  Result := S;
end;

function PInteractionManager.GetContainerMenuBarGroup(Button: TdxBarButton): TdxBarGroup;
var
  Group: TdxBarGroup;
  I: Integer;
begin
  Result := nil;
  for I := 0 to Button.BarManager.GroupCount - 1 do begin
    Group := Button.BarManager.Groups[I];
    if Group.IndexOf(Button) <> -1 then begin
      Result := Group;
      Exit;
    end;
  end;
end;

procedure PInteractionManager.BuildInteractions;
begin
  AddAllProfileElementIcons;
  BuildPredefinedInteractions;
  BuildExtendedInteractions;
  ChangePaletteVisibility(nil);  
end;

procedure PInteractionManager.AcquireAvailableNavBarGroups(Diagram: PUMLDiagram; NavBarGroups: TList);
var
  DI: PDiagramMenuInteraction;
  PI: PPaletteInteraction;
  I: Integer;
begin
  NavBarGroups.Clear;
  if Diagram.DiagramType = '' then
    DI := FindPredefinedDiagramMenuInteraction(GetDiagramKindName(Diagram))
  else
    DI := FindExtendedDiagramMenuInteraction(Diagram.DiagramType);
  // ASSERTIONS
  Assert(DI <> nil);
  // ASSERTIONS
  for I := 0 to DI.AvailablePaletteCount - 1 do begin
    PI := FindPaletteInteraction(DI.AvailablePalettes[I]);
    if PI <> nil then
      NavBarGroups.Add(PI.NavBarGroup);
  end;
end;

procedure PInteractionManager.SetExtMenuButtonsState(Owner: PModel);
var
  DI: PExtendedDiagramMenuInteraction;
  MI: PExtendedModelMenuInteraction;
  I: Integer;
begin
  for I := 0 to ModelMenuInteractionCount - 1 do begin
    if ModelMenuInteractions[I] is PExtendedModelMenuInteraction then begin
      MI := ModelMenuInteractions[I] as PExtendedModelMenuInteraction;
      // ASSERTIONS
      Assert(MI.ModelPrototype.ContainerModelCount > 0);
      Assert(MI.BaseMenuButton <> nil);
      // ASSERTIONS
      if (MI.BaseMenuButton.Visible = ivAlways) and ExtensionManager.IsIncluded(MI.ModelPrototype.Profile) and MI.IsOneOfContainer(Owner) then
        MI.MenuButton.Visible := ivAlways
      else
        MI.MenuButton.Visible := ivNever;
    end;
  end;
  for I := 0 to DiagramMenuInteractionCount - 1 do begin
    if DiagramMenuInteractions[I] is PExtendedDiagramMenuInteraction then begin
      DI := DiagramMenuInteractions[I] as PExtendedDiagramMenuInteraction;
      if not ExtensionManager.IsIncluded(DI.DiagramType.Profile) then
        DI.MenuButton.Visible := ivNever;
    end;
  end;
end;

procedure PInteractionManager.ChangePaletteVisibility(Diagram: PUMLDiagram);

  function GetFirstVisibleNavBarGroup(NavBarGroups: TList): TdxNavBarGroup;
  var
    I: Integer;
  begin
    Result := nil;
    for I := 0 to NavBarGroups.Count - 1 do
      if TdxNavBarGroup(NavBarGroups[I]).Visible then begin
        Result := NavBarGroups[I];
        Exit;
      end;
  end;

var
  NavBarGroups: TList;
  Profile: PProfile;
  Palette: PPalette;
  PI: PPaletteInteraction;
  I, J: Integer;
begin
  with MainForm do begin
    for I := 0 to PaletteNavBar.Groups.Count - 1 do
      PaletteNavBar.Groups[I].Visible := False;
    NavBarGroups := TList.Create;
    try
      if Diagram <> nil then begin
        AcquireAvailableNavBarGroups(Diagram, NavBarGroups);
        for I := 0 to NavBarGroups.Count - 1 do
          TdxNavBarGroup(NavBarGroups[I]).Visible := True;
        for I := 0 to ExtensionManager.AvailableProfileCount - 1 do begin
          Profile := ExtensionManager.AvailableProfiles[I];
          if not ExtensionManager.IsIncluded(Profile) then
            for J := 0 to Profile.PaletteCount - 1 do begin
              Palette := Profile.Palettes[J];
              PI := FindPaletteInteraction(Palette.Name);
              // ASSERTIONS
              Assert(PI <> nil);
              // ASSERTIONS
              PI.NavBarGroup.Visible := False;
            end;
        end;
        PaletteNavBar.ActiveGroup := GetFirstVisibleNavBarGroup(NavBarGroups);
        AnnotationNavBarGroup.Visible := True;
      end;
    finally
      NavBarGroups.Free;
    end;
  end;
end;

// PInteractionManager
////////////////////////////////////////////////////////////////////////////////

function DragTypeToSkeletonPaintKind(Value: PDragTypeKind): PSkeletonPaintingKind;
begin
  if Value = dkRect then
    Result := spRect
  else if Value = dkLine then
    Result := spLine
  else
    Result := spRect;
end;

end.
