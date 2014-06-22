library StarUMLProject;
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

uses
  ComServ,
  AboutFrm in 'AboutFrm.pas' {AboutForm},
  AddInMgr in 'AddInMgr.pas',
  AddInMgrFrm in 'AddInMgrFrm.pas' {AddInMgrForm},
  ApprMgr in 'ApprMgr.pas',
  AttachEdt in 'AttachEdt.pas' {AttachmentEditor: TFrame},
  AttachItemEdtFrm in 'AttachItemEdtFrm.pas' {AttachmentItemEditForm},
  BasicClasses in 'BasicClasses.pas',
  ClipboardMgr in 'ClipboardMgr.pas',
  CmdExec in 'CmdExec.pas',
  ColEdtFrm in 'ColEdtFrm.pas' {CollectionEditorForm},
  ConstEdtFrm in 'ConstEdtFrm.pas' {ConstraintEditorForm},
  ConstItemEdtFrm in 'ConstItemEdtFrm.pas' {ConstraintItemEditForm},
  ContributorMgr in 'ContributorMgr.pas',
  Core in 'Core.pas',
  CoreAuto in 'CoreAuto.pas',
  DiagramEditors in 'DiagramEditors.pas',
  DiagramExplorerFrame in 'DiagramExplorerFrame.pas' {DiagramExplorerPanel: TFrame},
  DiagramMapFrm in 'DiagramMapFrm.pas' {DiagramMapForm},
  DocuEdt in 'DocuEdt.pas' {DocumentationEditor: TFrame},
  ElemLstFrm in 'ElemLstFrm.pas' {ElementListForm},
  ElemSelFrm in 'ElemSelFrm.pas' {ElementSelectorForm},
  EventPub in 'EventPub.pas',
  ExprParsers in 'ExprParsers.pas',
  ExtCore in 'ExtCore.pas',
  ExtCoreAuto in 'ExtCoreAuto.pas',
  FindFrm in 'FindFrm.pas' {FindForm},
  FrwMgr in 'FrwMgr.pas',
  GraphicClasses in 'GraphicClasses.pas',
  Handlers in 'Handlers.pas',
  HtmlHlp in 'HtmlHlp.pas',
  ImportFrameworkFrm in 'ImportFrameworkFrm.pas' {ImportFrameworkForm},
  InspectorFrm in 'InspectorFrm.pas' {InspectorFrame: TFrame},
  InteractionMgr in 'InteractionMgr.pas',
  LayoutDgm in 'LayoutDgm.pas',
  LogMgr in 'LogMgr.pas',
  Main in 'Main.pas',
  MainFrm in 'MainFrm.pas' {MainForm},
  MessageFrame in 'MessageFrame.pas' {MessagePanel: TFrame},
  ModelExpFilterFrm in 'ModelExpFilterFrm.pas' {ModelExplorerFilterForm},
  ModelExplorerFrame in 'ModelExplorerFrame.pas' {ModelExplorerPanel: TFrame},
  ModelVerifierFrm in 'ModelVerifierFrm.pas' {ModelVerifierForm},
  NewProjFrm in 'NewProjFrm.pas' {NewProjFrm},
  NLS in 'NLS.pas',
  NLS_StarUML in 'NLS_StarUML.pas',
  NXMgr in 'NXMgr.pas',
  OptionDeps in 'OptionDeps.pas',
  OptMgr_TLB in 'OptMgr_TLB.pas',
  OutputFrame in 'OutputFrame.pas' {OutputPanel: TFrame},
  PageSetupFrm in 'PageSetupFrm.pas' {PageSetupForm},
  PGMR101Lib_TLB in 'PGMR101Lib_TLB.pas',
  PrintFrm in 'PrintFrm.pas' {PrintForm},
  PrintPreviewFrm in 'PrintPreviewFrm.pas' {PrintPreviewForm},
  ProfileMgrFrm in 'ProfileMgrFrm.pas' {ProfileManagerForm},
  ProjectMgr in 'ProjectMgr.pas',
  PropEdt in 'PropEdt.pas' {PropertyEditor: TFrame},
  QuickDialogFrm in 'QuickDialogFrm.pas' {QuickDialogForm},
  SelectionMgr in 'SelectionMgr.pas',
  ShortenSyntaxMgr in 'ShortenSyntaxMgr.pas',
  SplashFrm in 'SplashFrm.pas' {SplashForm},
  StarUMLApp in 'StarUMLApp.pas',
  StarUMLAppAuto in 'StarUMLAppAuto.pas',
  StereoSelFrm in 'StereoSelFrm.pas' {StereotypeSelectorForm},
  TagColEdtFrm in 'TagColEdtFrm.pas' {TaggedValueCollectionEditorForm},
  TagEdtFrm in 'TagEdtFrm.pas' {TaggedValueEditorForm},
  UMLAux in 'UMLAux.pas',
  UMLAuxAuto in 'UMLAuxAuto.pas',
  UMLFacto in 'UMLFacto.pas',
  UMLModels in 'UMLModels.pas',
  UMLModelsAuto in 'UMLModelsAuto.pas',
  UMLProps in 'UMLProps.pas',
  UMLVerify in 'UMLVerify.pas',
  UMLViews in 'UMLViews.pas',
  UMLViewsAuto in 'UMLViewsAuto.pas',
  ViewCore in 'ViewCore.pas',
  ViewCoreAuto in 'ViewCoreAuto.pas',
  WINGRAPHVIZLib_TLB in 'WINGRAPHVIZLib_TLB.pas',
  WorkingAreaFrm in 'WorkingAreaFrm.pas' {WorkingAreaFrame: TFrame},
  StarUMLDllControlUnit in 'StarUMLDllControlUnit.pas',
  StarUMLConstantsUnit in 'StarUMLConstantsUnit.pas',
  StarUMLProject_TLB in 'StarUMLProject_TLB.pas';

exports
  DllGetClassObject,
  DllCanUnloadNow,
  DllRegisterServer,
  DllUnregisterServer;
  
{$R *.TLB}

{$R *.RES}
begin
  ReportMemoryLeaksOnShutdown := True;
end.

