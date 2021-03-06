unit WSWordTranslator_TLB;

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

// $Rev: 52393 $
// File generated on 22/02/2014 15:02:56 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\JS\Delphi\WhiteStarSourceforgeTrunkXE5\staruml-generator\src\translators\word-translator\WordTranslator (1)
// LIBID: {B50752CF-E0EC-445E-BB82-B32E94A9C878}
// LCID: 0
// Helpfile:
// HelpString: WordTranslator Library
// DepndLst:
//   (1) v2.0 stdole, (C:\Windows\SysWow64\stdole2.tlb)
// SYS_KIND: SYS_WIN32
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers.
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL, Vcl.Graphics, Vcl.OleServer, Winapi.ActiveX;


// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:
//   Type Libraries     : LIBID_xxxx
//   CoClasses          : CLASS_xxxx
//   DISPInterfaces     : DIID_xxxx
//   Non-DISP interfaces: IID_xxxx
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  WSWordTranslatorMajorVersion = 1;
  WSWordTranslatorMinorVersion = 0;

  LIBID_WSWordTranslator: TGUID = '{B50752CF-E0EC-445E-BB82-B32E94A9C878}';

  IID_IWordTranslatorObj: TGUID = '{64F82205-5A1A-482D-A643-1E6A0BAA11FC}';
  CLASS_WordTranslatorObj: TGUID = '{15EDB416-C580-42FF-925B-D7960AF693A3}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary
// *********************************************************************//
  IWordTranslatorObj = interface;
  IWordTranslatorObjDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library
// (NOTE: Here we map each CoClass to its Default Interface)
// *********************************************************************//
  WordTranslatorObj = IWordTranslatorObj;


// *********************************************************************//
// Interface: IWordTranslatorObj
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {64F82205-5A1A-482D-A643-1E6A0BAA11FC}
// *********************************************************************//
  IWordTranslatorObj = interface(IDispatch)
    ['{64F82205-5A1A-482D-A643-1E6A0BAA11FC}']
  end;

// *********************************************************************//
// DispIntf:  IWordTranslatorObjDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {64F82205-5A1A-482D-A643-1E6A0BAA11FC}
// *********************************************************************//
  IWordTranslatorObjDisp = dispinterface
    ['{64F82205-5A1A-482D-A643-1E6A0BAA11FC}']
  end;

// *********************************************************************//
// The Class CoWordTranslatorObj provides a Create and CreateRemote method to
// create instances of the default interface IWordTranslatorObj exposed by
// the CoClass WordTranslatorObj. The functions are intended to be used by
// clients wishing to automate the CoClass objects exposed by the
// server of this typelibrary.
// *********************************************************************//
  CoWordTranslatorObj = class
    class function Create: IWordTranslatorObj;
    class function CreateRemote(const MachineName: string): IWordTranslatorObj;
  end;

implementation

uses System.Win.ComObj;

class function CoWordTranslatorObj.Create: IWordTranslatorObj;
begin
  Result := CreateComObject(CLASS_WordTranslatorObj) as IWordTranslatorObj;
end;

class function CoWordTranslatorObj.CreateRemote(const MachineName: string): IWordTranslatorObj;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_WordTranslatorObj) as IWordTranslatorObj;
end;

end.

