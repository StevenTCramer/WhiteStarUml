unit StarUMLDllControlUnit;

interface

procedure Start(const aCommand: string; const aInterface: IInterface); stdcall;
procedure Stop; stdcall;

exports Start;
exports Stop;

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
  PrintFrm,
  StarUMLProject_TLB;

var
  MainInstance: PMain;
  StarUMLApplicationSingleton :IStarUMLApplication;

procedure Start(const aCommand: string; const aInterface: IInterface);
var
  lCreateCOMServer: Boolean;
begin
  {$IFNDEF NOPACKAGES}
  lCreateCOMServer := ComServer.StartMode = smStandalone;
  if lCreateCOMServer then
  begin
    StarUMLApplicationSingleton := CoStarUMLApplication.Create;
    SplashForm := TSplashForm.Create(Application);
    SplashForm.Show;
    SplashForm.Repaint;
  end;
  {$ELSE}
    lCreateCOMServer := False;
  {$ENDIF}

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TModelVerifierForm, ModelVerifierForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TStereotypeSelectorForm, StereotypeSelectorForm);
  Application.CreateForm(TConstraintEditorForm, ConstraintEditorForm);
  Application.CreateForm(TTaggedValueCollectionEditorForm, TaggedValueCollectionEditorForm);
  Application.CreateForm(TTaggedValueEditorForm, TaggedValueEditorForm); // Mem leak
  Application.CreateForm(TElementSelectorForm, ElementSelectorForm);
  Application.CreateForm(TCollectionEditorForm, CollectionEditorForm);
  Application.CreateForm(TAttachmentItemEditForm, AttachmentItemEditForm);
  Application.CreateForm(TConstraintItemEditForm, ConstraintItemEditForm);
  Application.CreateForm(TProfileManagerForm, ProfileManagerForm);
  Application.CreateForm(TElementListForm, ElementListForm);
  Application.CreateForm(TNewProjectForm, NewProjectForm); // Mem Leak
  Application.CreateForm(TImportFrameworkForm, ImportFrameworkForm);
  Application.CreateForm(TFindForm, FindForm);
  Application.CreateForm(TAddInMgrForm, AddInMgrForm);
  Application.CreateForm(TModelExplorerFilterForm, ModelExplorerFilterForm);
  Application.CreateForm(TPageSetupForm, PageSetupForm);
  Application.CreateForm(TDiagramMapForm, DiagramMapForm);
  Application.CreateForm(TPrintPreviewForm, PrintPreviewForm);
  Application.CreateForm(TPrintForm, PrintForm);

  MainInstance := PMain.Create;
  MainInstance.Initialize_BeforeMainFormShow;
  
  if not lCreateCOMServer then
  begin
    MainForm.Visible := False;
    Application.ShowMainForm := False;
  end else
  begin
    MainForm.Visible := True;
    Application.ShowMainForm := True;
  end;
end;

procedure Stop;
begin
  PrintForm.Free;
  PrintPreviewForm.Free;
  DiagramMapForm.Free;
  PageSetupForm.Free;
  ModelExplorerFilterForm.Free;
  AddInMgrForm.Free;
  FindForm.Free;
  ImportFrameworkForm.Free;
  NewProjectForm.Free;
  ElementListForm.Free;
  ProfileManagerForm.Free;
  ConstraintItemEditForm.Free;
  AttachmentItemEditForm.Free;
  CollectionEditorForm.Free;
  ElementSelectorForm.Free;
  TaggedValueEditorForm.Free;
  TaggedValueCollectionEditorForm.Free;
  ConstraintEditorForm.Free;
  StereotypeSelectorForm.Free;
  AboutForm.Free;
  ModelVerifierForm.Free;
  MainForm.Free;

  MainInstance.Finalize_AfterMainFormClose;
  MainInstance.Free;
  StarUMLApplicationSingleton := nil;  
end;

end.
