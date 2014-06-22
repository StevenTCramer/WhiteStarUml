unit StarUMLDataModuleUnit;

interface

uses
  SysUtils,
  Classes;

const
  PERSONAL_EDITION = 'Personal';
  TRIAL_EDITION = '';
  COMMERCIAL_EDITION = '';

type

  TStarUMLDataModule = class(TDataModule)
    procedure DataModuleCreate(Sender: TObject);
  private
//    MainInstance: PMain;
  public
    class function Singleton: TStarUMLDataModule;
  end;

procedure Start(const aCommand: string; const aInterface: IInterface); stdcall;
procedure ShutDown; stdcall;

exports Start;
exports ShutDown;

implementation

uses
  ComServ,
  SplashFrm,
  Forms,
  AboutFrm,
  Main,
  MainFrm,
  ModelVerifierFrm,
  StereoSelFrm,
  ConstEdtFrm,
  TagColEdtFrm,
  TagEdtFrm,
  ElemSelFrm,
  AddInMgrFrm,
  AttachItemEdtFrm,
  ColEdtFrm,
  ConstItemEdtFrm,
  DiagramMapFrm,
  ElemLstFrm,
  FindFrm,
  ImportFrameworkFrm,
  ModelExpFilterFrm,
  PageSetupFrm,
  PrintPreviewFrm,
  ProfileMgrFrm,
  QuickDialogFrm,
  WorkingAreaFrm,
  NewProjFrm,
  PrintFrm;

var
  StarUMLDataModuleSingleton: TStarUMLDataModule;

  {$R *.dfm}

procedure TStarUMLDataModule.DataModuleCreate(Sender: TObject);
var
    MainInstance: PMain;
begin
  // Show Splash Form.
  if (ComServer.StartMode = smStandalone) then
  begin
    SplashForm := TSplashForm.Create(Application);
    SplashForm.Show;
    SplashForm.Repaint;
  end;

  Application.Title := 'StarUML';
  Application.HelpFile := 'StarUML.chm';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TModelVerifierForm, ModelVerifierForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TStereotypeSelectorForm, StereotypeSelectorForm);
  Application.CreateForm(TConstraintEditorForm, ConstraintEditorForm);
  Application.CreateForm(TTaggedValueCollectionEditorForm, TaggedValueCollectionEditorForm);
  Application.CreateForm(TTaggedValueEditorForm, TaggedValueEditorForm);
  Application.CreateForm(TElementSelectorForm, ElementSelectorForm);
  Application.CreateForm(TCollectionEditorForm, CollectionEditorForm);
  Application.CreateForm(TAttachmentItemEditForm, AttachmentItemEditForm);
  Application.CreateForm(TConstraintItemEditForm, ConstraintItemEditForm);
  Application.CreateForm(TProfileManagerForm, ProfileManagerForm);
  Application.CreateForm(TElementListForm, ElementListForm);
  Application.CreateForm(TNewProjectForm, NewProjectForm);
  Application.CreateForm(TImportFrameworkForm, ImportFrameworkForm);
  Application.CreateForm(TFindForm, FindForm);
  Application.CreateForm(TAddInMgrForm, AddInMgrForm);
  Application.CreateForm(TModelExplorerFilterForm, ModelExplorerFilterForm);
  Application.CreateForm(TPageSetupForm, PageSetupForm);
  Application.CreateForm(TDiagramMapForm, DiagramMapForm);
  Application.CreateForm(TPrintPreviewForm, PrintPreviewForm);
  Application.CreateForm(TPrintForm, PrintForm);

  if (ComServer.StartMode <> smStandalone) then
  begin
    MainForm.Visible := False;
    Application.ShowMainForm := False;
  end;

  MainInstance := PMain.Create;
  MainInstance.Initialize_BeforeMainFormShow;
end;

procedure Start(const aCommand: string; const aInterface: IInterface);
begin
//  TTWECommandLineHelper.Singleton.CommandLineParams := aCommand;
  TStarUMLDataModule.Singleton;
end;

procedure ShutDown;
begin
  MainInstance.Finalize_AfterMainFormClose;
  MainInstance.Free;
end;

class function TStarUMLDataModule.Singleton: TStarUMLDataModule;
begin
  if not Assigned(StarUMLDataModuleSingleton) then
  begin
    StarUMLDataModuleSingleton := TStarUMLDataModule.Create(nil);
  end;
  Result := StarUMLDataModuleSingleton;
end;

end.

