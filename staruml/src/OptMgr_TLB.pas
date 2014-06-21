unit OptMgr_TLB;

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

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : $Revision: 1.2 $
// File generated on 2002-10-04 ¿ÀÈÄ 5:24:54 from Type Library described below.

// ************************************************************************  //
// Type Lib: F:\WorkPlastic2002\OptionManager\OptMgr.dll (1)
// LIBID: {C5EF8E94-B2FE-4709-A92A-D9A50940AE9C}
// LCID: 0
// Helpfile: 
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINNT\System32\Stdole2.tlb)
//   (2) v4.0 StdVCL, (C:\WINNT\System32\STDVCL40.DLL)
// Errors:
//   Hint: Member 'Type' of 'IOptionItem' changed to 'Type_'
// ************************************************************************ //
// *************************************************************************//
// NOTE:                                                                      
// Items guarded by $IFDEF_LIVE_SERVER_AT_DESIGN_TIME are used by properties  
// which return objects that may need to be explicitly created via a function 
// call prior to any access via the property. These items have been disabled  
// in order to prevent accidental use from within the object inspector. You   
// may enable them by defining LIVE_SERVER_AT_DESIGN_TIME or by selectively   
// removing them from the $IFDEF blocks. However, such items must still be    
// programmatically created via a method of the appropriate CoClass before    
// they can be used.                                                          
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  OptMgrMajorVersion = 1;
  OptMgrMinorVersion = 0;

  LIBID_OptMgr: TGUID = '{C5EF8E94-B2FE-4709-A92A-D9A50940AE9C}';

  IID_IOptionItem: TGUID = '{C8E6BA96-EE0F-463E-B9BC-776C15167809}';
  IID_IOptionClassification: TGUID = '{A2FB7B59-01A9-4929-BC56-79A699A35E90}';
  IID_IOptionCategory: TGUID = '{C6C2AE66-AEE8-43C0-AA77-081646262CF2}';
  IID_IOptionSchema: TGUID = '{DA4FB79C-B8B5-4573-98E8-8CB2ECFA0406}';
  IID_IOptionManager: TGUID = '{D041BEEF-82ED-4A66-843A-4D08339C228D}';
  CLASS_OptionManager: TGUID = '{E109632F-9B41-4FB9-89FE-DE416C0256AA}';

// *********************************************************************//
// Declaration of Enumerations defined in Type Library                    
// *********************************************************************//
// Constants for enum OptionType
type
  OptionType = TOleEnum;
const
  otInteger = $00000000;
  otReal = $00000001;
  otString = $00000002;
  otBoolean = $00000003;
  otText = $00000004;
  otEnumeration = $00000005;
  otFileName = $00000006;
  otPathName = $00000007;
  otColor = $00000008;
  otRange = $00000009;

type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IOptionItem = interface;
  IOptionItemDisp = dispinterface;
  IOptionClassification = interface;
  IOptionClassificationDisp = dispinterface;
  IOptionCategory = interface;
  IOptionCategoryDisp = dispinterface;
  IOptionSchema = interface;
  IOptionSchemaDisp = dispinterface;
  IOptionManager = interface;
  IOptionManagerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  OptionManager = IOptionManager;


// *********************************************************************//
// Interface: IOptionItem
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C8E6BA96-EE0F-463E-B9BC-776C15167809}
// *********************************************************************//
  IOptionItem = interface(IDispatch)
    ['{C8E6BA96-EE0F-463E-B9BC-776C15167809}']
    function Get_Type_: OptionType; safecall;
    procedure Set_Type_(Value: OptionType); safecall;
    function Get_Key: WideString; safecall;
    procedure Set_Key(const Value: WideString); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Value: OleVariant; safecall;
    procedure Set_Value(Value: OleVariant); safecall;
    function Get_DefaultValue: OleVariant; safecall;
    procedure Set_DefaultValue(Value: OleVariant); safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(const Value: WideString); safecall;
    function Get_Changed: WordBool; safecall;
    procedure Set_Changed(Value: WordBool); safecall;
    property Type_: OptionType read Get_Type_ write Set_Type_;
    property Key: WideString read Get_Key write Set_Key;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Value: OleVariant read Get_Value write Set_Value;
    property DefaultValue: OleVariant read Get_DefaultValue write Set_DefaultValue;
    property Description: WideString read Get_Description write Set_Description;
    property Changed: WordBool read Get_Changed write Set_Changed;
  end;

// *********************************************************************//
// DispIntf:  IOptionItemDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C8E6BA96-EE0F-463E-B9BC-776C15167809}
// *********************************************************************//
  IOptionItemDisp = dispinterface
    ['{C8E6BA96-EE0F-463E-B9BC-776C15167809}']
    property Type_: OptionType dispid 1;
    property Key: WideString dispid 2;
    property Caption: WideString dispid 3;
    property Value: OleVariant dispid 4;
    property DefaultValue: OleVariant dispid 5;
    property Description: WideString dispid 6;
    property Changed: WordBool dispid 7;
  end;

// *********************************************************************//
// Interface: IOptionClassification
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A2FB7B59-01A9-4929-BC56-79A699A35E90}
// *********************************************************************//
  IOptionClassification = interface(IDispatch)
    ['{A2FB7B59-01A9-4929-BC56-79A699A35E90}']
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(const Value: WideString); safecall;
    function GetOptionItemCount: Integer; safecall;
    function GetOptionItemAt(Index: Integer): IOptionItem; safecall;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Description: WideString read Get_Description write Set_Description;
  end;

// *********************************************************************//
// DispIntf:  IOptionClassificationDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {A2FB7B59-01A9-4929-BC56-79A699A35E90}
// *********************************************************************//
  IOptionClassificationDisp = dispinterface
    ['{A2FB7B59-01A9-4929-BC56-79A699A35E90}']
    property Caption: WideString dispid 1;
    property Description: WideString dispid 2;
    function GetOptionItemCount: Integer; dispid 3;
    function GetOptionItemAt(Index: Integer): IOptionItem; dispid 4;
  end;

// *********************************************************************//
// Interface: IOptionCategory
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C6C2AE66-AEE8-43C0-AA77-081646262CF2}
// *********************************************************************//
  IOptionCategory = interface(IDispatch)
    ['{C6C2AE66-AEE8-43C0-AA77-081646262CF2}']
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(const Value: WideString); safecall;
    function GetOptionClassificationCount: Integer; safecall;
    function GetOptionClassificationAt(Index: Integer): IOptionClassification; safecall;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Description: WideString read Get_Description write Set_Description;
  end;

// *********************************************************************//
// DispIntf:  IOptionCategoryDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {C6C2AE66-AEE8-43C0-AA77-081646262CF2}
// *********************************************************************//
  IOptionCategoryDisp = dispinterface
    ['{C6C2AE66-AEE8-43C0-AA77-081646262CF2}']
    property Caption: WideString dispid 1;
    property Description: WideString dispid 2;
    function GetOptionClassificationCount: Integer; dispid 3;
    function GetOptionClassificationAt(Index: Integer): IOptionClassification; dispid 4;
  end;

// *********************************************************************//
// Interface: IOptionSchema
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DA4FB79C-B8B5-4573-98E8-8CB2ECFA0406}
// *********************************************************************//
  IOptionSchema = interface(IDispatch)
    ['{DA4FB79C-B8B5-4573-98E8-8CB2ECFA0406}']
    function Get_ID: WideString; safecall;
    procedure Set_ID(const Value: WideString); safecall;
    function Get_Caption: WideString; safecall;
    procedure Set_Caption(const Value: WideString); safecall;
    function Get_Description: WideString; safecall;
    procedure Set_Description(const Value: WideString); safecall;
    function GetOptionCategoryCount: Integer; safecall;
    function GetOptionCategoryAt(Index: Integer): IOptionCategory; safecall;
    property ID: WideString read Get_ID write Set_ID;
    property Caption: WideString read Get_Caption write Set_Caption;
    property Description: WideString read Get_Description write Set_Description;
  end;

// *********************************************************************//
// DispIntf:  IOptionSchemaDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {DA4FB79C-B8B5-4573-98E8-8CB2ECFA0406}
// *********************************************************************//
  IOptionSchemaDisp = dispinterface
    ['{DA4FB79C-B8B5-4573-98E8-8CB2ECFA0406}']
    property ID: WideString dispid 1;
    property Caption: WideString dispid 3;
    property Description: WideString dispid 4;
    function GetOptionCategoryCount: Integer; dispid 5;
    function GetOptionCategoryAt(Index: Integer): IOptionCategory; dispid 6;
  end;

// *********************************************************************//
// Interface: IOptionManager
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D041BEEF-82ED-4A66-843A-4D08339C228D}
// *********************************************************************//
  IOptionManager = interface(IDispatch)
    ['{D041BEEF-82ED-4A66-843A-4D08339C228D}']
    function Get_SchemataRegPath: WideString; safecall;
    procedure Set_SchemataRegPath(const Value: WideString); safecall;
    function Get_OptionsRegPath: WideString; safecall;
    procedure Set_OptionsRegPath(const Value: WideString); safecall;
    function Get_DefaultSchemaID: WideString; safecall;
    procedure Set_DefaultSchemaID(const Value: WideString); safecall;
    function GetOptionSchemaCount: Integer; safecall;
    function GetOptionSchemaAt(Index: Integer): IOptionSchema; safecall;
    procedure InitOptionManager(const SchemataRegPath: WideString; 
                                const OptionsRegPath: WideString; const DefaultSchemaID: WideString); safecall;
    function FindOptionItem(const SchemaID: WideString; const Key: WideString): IOptionItem; safecall;
    function ShowDialog: WordBool; safecall;
    function GetOptionValue(const SchemaID: WideString; const Key: WideString): OleVariant; safecall;
    procedure LoadOptionValues; safecall;
    procedure SaveOptionValues; safecall;
    property SchemataRegPath: WideString read Get_SchemataRegPath write Set_SchemataRegPath;
    property OptionsRegPath: WideString read Get_OptionsRegPath write Set_OptionsRegPath;
    property DefaultSchemaID: WideString read Get_DefaultSchemaID write Set_DefaultSchemaID;
  end;

// *********************************************************************//
// DispIntf:  IOptionManagerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {D041BEEF-82ED-4A66-843A-4D08339C228D}
// *********************************************************************//
  IOptionManagerDisp = dispinterface
    ['{D041BEEF-82ED-4A66-843A-4D08339C228D}']
    property SchemataRegPath: WideString dispid 1;
    property OptionsRegPath: WideString dispid 2;
    property DefaultSchemaID: WideString dispid 3;
    function GetOptionSchemaCount: Integer; dispid 4;
    function GetOptionSchemaAt(Index: Integer): IOptionSchema; dispid 5;
    procedure InitOptionManager(const SchemataRegPath: WideString; 
                                const OptionsRegPath: WideString; const DefaultSchemaID: WideString); dispid 6;
    function FindOptionItem(const SchemaID: WideString; const Key: WideString): IOptionItem; dispid 7;
    function ShowDialog: WordBool; dispid 8;
    function GetOptionValue(const SchemaID: WideString; const Key: WideString): OleVariant; dispid 9;
    procedure LoadOptionValues; dispid 10;
    procedure SaveOptionValues; dispid 11;
  end;

// *********************************************************************//
// The Class CoOptionManager provides a Create and CreateRemote method to          
// create instances of the default interface IOptionManager exposed by              
// the CoClass OptionManager. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoOptionManager = class
    class function Create: IOptionManager;
    class function CreateRemote(const MachineName: string): IOptionManager;
  end;


// *********************************************************************//
// OLE Server Proxy class declaration
// Server Object    : TOptionManager
// Help String      : 
// Default Interface: IOptionManager
// Def. Intf. DISP? : No
// Event   Interface: 
// TypeFlags        : (2) CanCreate
// *********************************************************************//
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  TOptionManagerProperties= class;
{$ENDIF}
  TOptionManager = class(TOleServer)
  private
    FIntf:        IOptionManager;
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    FProps:       TOptionManagerProperties;
    function      GetServerProperties: TOptionManagerProperties;
{$ENDIF}
    function      GetDefaultInterface: IOptionManager;
  protected
    procedure InitServerData; override;
    function Get_SchemataRegPath: WideString;
    procedure Set_SchemataRegPath(const Value: WideString);
    function Get_OptionsRegPath: WideString;
    procedure Set_OptionsRegPath(const Value: WideString);
    function Get_DefaultSchemaID: WideString;
    procedure Set_DefaultSchemaID(const Value: WideString);
  public
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure Connect; override;
    procedure ConnectTo(svrIntf: IOptionManager);
    procedure Disconnect; override;
    function GetOptionSchemaCount: Integer;
    function GetOptionSchemaAt(Index: Integer): IOptionSchema;
    procedure InitOptionManager(const SchemataRegPath: WideString; 
                                const OptionsRegPath: WideString; const DefaultSchemaID: WideString);
    function FindOptionItem(const SchemaID: WideString; const Key: WideString): IOptionItem;
    function ShowDialog: WordBool;
    function GetOptionValue(const SchemaID: WideString; const Key: WideString): OleVariant;
    procedure LoadOptionValues;
    procedure SaveOptionValues;
    property DefaultInterface: IOptionManager read GetDefaultInterface;
    property SchemataRegPath: WideString read Get_SchemataRegPath write Set_SchemataRegPath;
    property OptionsRegPath: WideString read Get_OptionsRegPath write Set_OptionsRegPath;
    property DefaultSchemaID: WideString read Get_DefaultSchemaID write Set_DefaultSchemaID;
  published
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
    property Server: TOptionManagerProperties read GetServerProperties;
{$ENDIF}
  end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
// *********************************************************************//
// OLE Server Properties Proxy Class
// Server Object    : TOptionManager
// (This object is used by the IDE's Property Inspector to allow editing
//  of the properties of this server)
// *********************************************************************//
 TOptionManagerProperties = class(TPersistent)
  private
    FServer:    TOptionManager;
    function    GetDefaultInterface: IOptionManager;
    constructor Create(AServer: TOptionManager);
  protected
    function Get_SchemataRegPath: WideString;
    procedure Set_SchemataRegPath(const Value: WideString);
    function Get_OptionsRegPath: WideString;
    procedure Set_OptionsRegPath(const Value: WideString);
    function Get_DefaultSchemaID: WideString;
    procedure Set_DefaultSchemaID(const Value: WideString);
  public
    property DefaultInterface: IOptionManager read GetDefaultInterface;
  published
    property SchemataRegPath: WideString read Get_SchemataRegPath write Set_SchemataRegPath;
    property OptionsRegPath: WideString read Get_OptionsRegPath write Set_OptionsRegPath;
    property DefaultSchemaID: WideString read Get_DefaultSchemaID write Set_DefaultSchemaID;
  end;
{$ENDIF}


procedure Register;

resourcestring
  dtlServerPage = 'StarUML';

implementation

uses ComObj;

class function CoOptionManager.Create: IOptionManager;
begin
  Result := CreateComObject(CLASS_OptionManager) as IOptionManager;
end;

class function CoOptionManager.CreateRemote(const MachineName: string): IOptionManager;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_OptionManager) as IOptionManager;
end;

procedure TOptionManager.InitServerData;
const
  CServerData: TServerData = (
    ClassID:   '{E109632F-9B41-4FB9-89FE-DE416C0256AA}';
    IntfIID:   '{D041BEEF-82ED-4A66-843A-4D08339C228D}';
    EventIID:  '';
    LicenseKey: nil;
    Version: 500);
begin
  ServerData := @CServerData;
end;

procedure TOptionManager.Connect;
var
  punk: IUnknown;
begin
  if FIntf = nil then
  begin
    punk := GetServer;
    Fintf:= punk as IOptionManager;
  end;
end;

procedure TOptionManager.ConnectTo(svrIntf: IOptionManager);
begin
  Disconnect;
  FIntf := svrIntf;
end;

procedure TOptionManager.DisConnect;
begin
  if Fintf <> nil then
  begin
    FIntf := nil;
  end;
end;

function TOptionManager.GetDefaultInterface: IOptionManager;
begin
  if FIntf = nil then
    Connect;
  Assert(FIntf <> nil, 'DefaultInterface is NULL. Component is not connected to Server. You must call ''Connect'' or ''ConnectTo'' before this operation');
  Result := FIntf;
end;

constructor TOptionManager.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps := TOptionManagerProperties.Create(Self);
{$ENDIF}
end;

destructor TOptionManager.Destroy;
begin
{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
  FProps.Free;
{$ENDIF}
  inherited Destroy;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
function TOptionManager.GetServerProperties: TOptionManagerProperties;
begin
  Result := FProps;
end;
{$ENDIF}

function TOptionManager.Get_SchemataRegPath: WideString;
begin
    Result := DefaultInterface.SchemataRegPath;
end;

procedure TOptionManager.Set_SchemataRegPath(const Value: WideString);
  { Warning: The property SchemataRegPath has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.SchemataRegPath := Value;
end;

function TOptionManager.Get_OptionsRegPath: WideString;
begin
    Result := DefaultInterface.OptionsRegPath;
end;

procedure TOptionManager.Set_OptionsRegPath(const Value: WideString);
  { Warning: The property OptionsRegPath has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.OptionsRegPath := Value;
end;

function TOptionManager.Get_DefaultSchemaID: WideString;
begin
    Result := DefaultInterface.DefaultSchemaID;
end;

procedure TOptionManager.Set_DefaultSchemaID(const Value: WideString);
  { Warning: The property DefaultSchemaID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultSchemaID := Value;
end;

function TOptionManager.GetOptionSchemaCount: Integer;
begin
  Result := DefaultInterface.GetOptionSchemaCount;
end;

function TOptionManager.GetOptionSchemaAt(Index: Integer): IOptionSchema;
begin
  Result := DefaultInterface.GetOptionSchemaAt(Index);
end;

procedure TOptionManager.InitOptionManager(const SchemataRegPath: WideString; 
                                           const OptionsRegPath: WideString; 
                                           const DefaultSchemaID: WideString);
begin
  DefaultInterface.InitOptionManager(SchemataRegPath, OptionsRegPath, DefaultSchemaID);
end;

function TOptionManager.FindOptionItem(const SchemaID: WideString; const Key: WideString): IOptionItem;
begin
  Result := DefaultInterface.FindOptionItem(SchemaID, Key);
end;

function TOptionManager.ShowDialog: WordBool;
begin
  Result := DefaultInterface.ShowDialog;
end;

function TOptionManager.GetOptionValue(const SchemaID: WideString; const Key: WideString): OleVariant;
begin
  Result := DefaultInterface.GetOptionValue(SchemaID, Key);
end;

procedure TOptionManager.LoadOptionValues;
begin
  DefaultInterface.LoadOptionValues;
end;

procedure TOptionManager.SaveOptionValues;
begin
  DefaultInterface.SaveOptionValues;
end;

{$IFDEF LIVE_SERVER_AT_DESIGN_TIME}
constructor TOptionManagerProperties.Create(AServer: TOptionManager);
begin
  inherited Create;
  FServer := AServer;
end;

function TOptionManagerProperties.GetDefaultInterface: IOptionManager;
begin
  Result := FServer.DefaultInterface;
end;

function TOptionManagerProperties.Get_SchemataRegPath: WideString;
begin
    Result := DefaultInterface.SchemataRegPath;
end;

procedure TOptionManagerProperties.Set_SchemataRegPath(const Value: WideString);
  { Warning: The property SchemataRegPath has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.SchemataRegPath := Value;
end;

function TOptionManagerProperties.Get_OptionsRegPath: WideString;
begin
    Result := DefaultInterface.OptionsRegPath;
end;

procedure TOptionManagerProperties.Set_OptionsRegPath(const Value: WideString);
  { Warning: The property OptionsRegPath has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.OptionsRegPath := Value;
end;

function TOptionManagerProperties.Get_DefaultSchemaID: WideString;
begin
    Result := DefaultInterface.DefaultSchemaID;
end;

procedure TOptionManagerProperties.Set_DefaultSchemaID(const Value: WideString);
  { Warning: The property DefaultSchemaID has a setter and a getter whose
  types do not match. Delphi was unable to generate a property of
  this sort and so is using a Variant to set the property instead. }
var
  InterfaceVariant: OleVariant;
begin
  InterfaceVariant := DefaultInterface;
  InterfaceVariant.DefaultSchemaID := Value;
end;

{$ENDIF}

procedure Register;
begin
  RegisterComponents(dtlServerPage, [TOptionManager]);
end;

end.
