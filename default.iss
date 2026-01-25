;Copyright (c) Anthony Beaumont
;This source code is licensed under the MIT License
;found in the LICENSE file in the root directory of this source tree.

[Setup]
AppId={#npm_package_name}
AppName={#npm_package_name}
AppVerName={#npm_package_name}
AppVersion={#npm_package_version}
VersionInfoVersion={#npm_package_version}
VersionInfoCopyright=Copyright © {#npm_package_author}
AppPublisher={#npm_package_author}
AppPublisherURL={#npm_package_homepage}
VersionInfoDescription={#npm_package_name}
DefaultDirName={commonpf}\{#npm_package_name}
  DirExistsWarning=no
DefaultGroupName={#npm_package_name}
Compression=lzma2/max
DiskSpanning=no
SolidCompression=no
AllowRootDirectory=yes
DisableWelcomePage=no
DisableReadyPage=yes
DisableDirPage=no
DisableFinishedPage=no
DisableProgramGroupPage=yes
Uninstallable=GetOption('CreateUninstaller')
UninstallFilesDir={app}\__unins__
UninstallDisplayIcon={app}\{#npm_package_name}.exe
RestartIfNeededByRun=no
CloseApplications=force
#if "x64" == npm_config_arch
  ArchitecturesAllowed=x64compatible
  ArchitecturesInstallIn64BitMode=x64compatible
#endif

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"

[Messages]
WelcomeLabel1={#npm_package_name} %nSetup Wizard
FinishedHeadingLabel={#npm_package_name} %nSetup Wizard

[CustomMessages]
en.InstallingLabel=Installing %1, please wait...
en.UninstallProgram=Uninstall %1
en.Options=Options
en.CreateDesktopIcon=Create Desktop icon
en.CreateStartMenu=Create Start Menu entry
en.CreateUninstaller=Create Uninstaller
en.CreateBootEntry=Start with Windows
en.ButtonDonate=Donate

[Files]
Source: "build\app\*"; DestDir: "{app}"; Flags: ignoreversion overwritereadonly recursesubdirs createallsubdirs;
    
[Icons]
Name: "{commondesktop}\{#npm_package_name}"; Filename: "{app}\{#npm_package_name}.exe"; Parameters: ""; WorkingDir: "{app}"; IconFilename: "{app}\icon.ico"; Check: GetOption('CreateDesktopIcon');
Name: "{commonstartup}\{#npm_package_name}"; Filename: "{app}\{#npm_package_name}.exe"; Parameters: ""; WorkingDir: "{app}"; IconFilename: "{app}\icon.ico"; Check: GetOption('CreateBootEntry');
Name: "{group}\{#npm_package_name}"; Filename: "{app}\{#npm_package_name}.exe"; WorkingDir: "{app}"; IconFilename: "{app}\icon.ico"; Check: GetOption('CreateStartMenu');
Name: "{group}\{cm:UninstallProgram,{#npm_package_name}}"; Filename: "{uninstallexe}"; WorkingDir: "{app}\__unins__"; Check: GetOption('CreateUninstaller');

[Run]
;PostInstall Checkbox
Filename: "{app}\{#npm_package_name}.exe"; WorkingDir: "{app}"; Description: "Run {#npm_package_name}"; Flags: runasoriginaluser postinstall nowait skipifsilent skipifdoesntexist unchecked

[UninstallDelete]

[UninstallRun]

[Registry]

[Code]

procedure GoToWebsite(Sender: TObject);
var 
  ResultCode: Integer;
begin
    ShellExec('','{#npm_package_homepage}', '', '', SW_SHOW, ewNoWait, ResultCode);
end;

procedure GoToDonation(Sender: TObject);
var 
  ResultCode: Integer;
begin
    ShellExec('','{#npm_package_funding}', '', '', SW_SHOW, ewNoWait, ResultCode);
end;

procedure CreateCopyright;
var
  Copyright, CopyrightURL: TLabel;
begin
  Copyright               := TLabel.Create(WizardForm);
  Copyright.Top           := WizardForm.NextButton.top - ScaleY(4);
  Copyright.Left          := ScaleX(5);
  Copyright.Caption       := 'Copyright © {#npm_package_author}';
  Copyright.AutoSize      := True;
  Copyright.Parent        := WizardForm;

  CopyrightURL            := TLabel.Create(WizardForm);
  CopyrightURL.Top        := Copyright.Top + ScaleY(15);
  CopyrightURL.Left       := Copyright.Left;
  CopyrightURL.Caption    := '{#npm_package_homepage}';
  CopyrightURL.Cursor     := crHand;
  CopyrightURL.Font.Color := clBlue;
  CopyrightURL.Font.Style := [fsUnderline];
  CopyrightURL.AutoSize   := True;
  CopyrightURL.Parent     := WizardForm;
  CopyrightURL.OnClick    := @GoToWebsite;
end;

var CreateStartMenu, CreateDesktopIcon, CreateBootEntry, CreateUninstaller : TNewCheckBox;

function GetOption (option: string) : boolean;
begin
    if option = 'CreateStartMenu' then begin
        Result:= CreateStartMenu.checked;
    end else if (option = 'CreateDesktopIcon') and (WizardSilent) then begin
        Result:= False;
    end else if option = 'CreateDesktopIcon' then begin
        Result:= CreateDesktopIcon.checked;
    end else if option = 'CreateUninstaller' then begin
        Result:= CreateUninstaller.checked;
    end else if (option = 'CreateBootEntry') and (WizardSilent) then begin
        Result:= False;
    end else if option = 'CreateBootEntry' then begin
        Result:= CreateBootEntry.checked;
    end;
end;

procedure ModifyWizardSelectDirPage;
var
    CheckBoxTitle: TLabel;
begin

CheckBoxTitle             := TLabel.Create(WizardForm);
CheckBoxTitle.Parent      :=  WizardForm.SelectDirPage;
CheckBoxTitle.Top         := ScaleY(100);
CheckBoxTitle.Caption     := ExpandConstant(' {cm:Options}:');

CreateDesktopIcon         := TNewCheckBox.Create(WizardForm);
CreateDesktopIcon.Parent  := WizardForm.SelectDirPage;
CreateDesktopIcon.Top     := CheckBoxTitle.Top + ScaleY(20);
CreateDesktopIcon.Left    := ScaleX(20);
CreateDesktopIcon.Width   := WizardForm.SelectDirPage.Width;
CreateDesktopIcon.Caption := ExpandConstant(' {cm:CreateDesktopIcon}.');
CreateDesktopIcon.Checked := True;

CreateStartMenu           := TNewCheckBox.Create(WizardForm);
CreateStartMenu.Parent    := WizardForm.SelectDirPage;
CreateStartMenu.Top       := CreateDesktopIcon.Top + ScaleY(20);
CreateStartMenu.Left      := ScaleX(20);
CreateStartMenu.Width     := WizardForm.SelectDirPage.Width;
CreateStartMenu.Caption   := ExpandConstant(' {cm:CreateStartMenu}.');
CreateStartMenu.Checked   := True;

CreateUninstaller         := TNewCheckBox.Create(WizardForm);
CreateUninstaller.Parent  := WizardForm.SelectDirPage;
CreateUninstaller.Top     := CreateStartMenu.Top + ScaleY(20);
CreateUninstaller.Left    := ScaleX(20);
CreateUninstaller.Width   := WizardForm.SelectDirPage.Width;
CreateUninstaller.Caption := ExpandConstant(' {cm:CreateUninstaller}.');
CreateUninstaller.Checked := True;

CreateBootEntry           := TNewCheckBox.Create(WizardForm);
CreateBootEntry.Parent    := WizardForm.SelectDirPage;
CreateBootEntry.Top       := CreateUninstaller.Top + ScaleY(20);
CreateBootEntry.Left      := ScaleX(20);
CreateBootEntry.Width     := WizardForm.SelectDirPage.Width;
CreateBootEntry.Caption   := ExpandConstant(' {cm:CreateBootEntry}.');
CreateBootEntry.Checked   := False;
end;

function GetTickCount: DWORD;
  external 'GetTickCount@kernel32.dll stdcall';

var
  StartTick: DWORD;
  PercentLabel, ElapsedLabel, RemainingLabel, StatusLabel : TNewStaticText;

procedure ModifyWizardInstallingPage;
begin

  WizardForm.FilenameLabel.Visible  := False;
  WizardForm.StatusLabel.top        := WizardForm.FilenameLabel.Top;
  WizardForm.StatusLabel.Visible    := False;
  WizardForm.ProgressGauge.width    := WizardForm.ProgressGauge.width - ScaleX(40);

  StatusLabel           := TNewStaticText.Create(WizardForm);
  StatusLabel.Parent    := WizardForm.FilenameLabel.Parent;
  StatusLabel.Left      := WizardForm.FilenameLabel.Left;
  StatusLabel.Top       := WizardForm.FilenameLabel.Top;
  StatusLabel.Width     := WizardForm.FilenameLabel.Width;
  StatusLabel.Height    := WizardForm.FilenameLabel.Height;
  StatusLabel.Caption   := ExpandConstant('{cm:InstallingLabel,{#npm_package_name}}');

  PercentLabel          := TNewStaticText.Create(WizardForm);
  PercentLabel.Parent   := WizardForm.ProgressGauge.Parent;
  PercentLabel.Left     := WizardForm.ProgressGauge.width + 11;
  PercentLabel.Top      := WizardForm.ProgressGauge.Top + 4;

  ElapsedLabel          := TNewStaticText.Create(WizardForm);
  ElapsedLabel.Parent   := WizardForm.ProgressGauge.Parent;
  ElapsedLabel.Left     := 0;
  ElapsedLabel.Top      := WizardForm.ProgressGauge.Top + WizardForm.ProgressGauge.Height + 10;

  RemainingLabel        := TNewStaticText.Create(WizardForm);
  RemainingLabel.Parent := WizardForm.ProgressGauge.Parent;
  RemainingLabel.Left   := ElapsedLabel.width + ScaleX(255);
  RemainingLabel.Top    := ElapsedLabel.Top;

end;

function TicksToStr(Value: DWORD): string;
var
  I: DWORD;
  Hours, Minutes, Seconds: Integer;
begin
  I := Value div 1000;
  Seconds := I mod 60;
  I := I div 60;
  Minutes := I mod 60;
  I := I div 60;
  Hours := I mod 24;
  Result := Format('%.2d:%.2d:%.2d', [Hours, Minutes, Seconds]);
end;

procedure CurPageChanged(CurPageID: Integer);
var
  DonateButton: TNewButton;
begin
  WizardForm.BackButton.Enabled := False;
  WizardForm.BackButton.Visible := False;

  if CurPageID = wpInstalling then
    StartTick := GetTickCount;

  if CurPageID = wpFinished then begin
    DonateButton          := TNewButton.Create(WizardForm);
    DonateButton.Parent   := WizardForm;
    DonateButton.Left     := WizardForm.CancelButton.Left;
    DonateButton.Top      := WizardForm.CancelButton.Top;
    DonateButton.Width    := WizardForm.CancelButton.Width;
    DonateButton.Height   := WizardForm.CancelButton.Height;
    DonateButton.Caption  := ExpandConstant('&{cm:ButtonDonate}');
    DonateButton.OnClick  := @GoToDonation;
  end;
end;

procedure CancelButtonClick(CurPageID: Integer; var Cancel, Confirm: Boolean);
begin
  if CurPageID = wpInstalling then
  begin
    Cancel := False;
    if ExitSetupMsgBox then
    begin
      Cancel                  := True;
      Confirm                 := False;
      PercentLabel.Visible    := False;
      ElapsedLabel.Visible    := False;
      RemainingLabel.Visible  := False;
    end;
  end;
end;

procedure CurInstallProgressChanged(CurProgress, MaxProgress: Integer);
var
  CurTick: DWORD;
begin
  CurTick := GetTickCount;
  if CurProgress = MaxProgress then 
  begin
      StatusLabel.Visible             := False;
      PercentLabel.Visible            := False;
      ElapsedLabel.Visible            := False;
      RemainingLabel.Visible          := False;
      WizardForm.StatusLabel.Visible  := true;
  end else if CurProgress > 0 then
  begin
    RemainingLabel.Caption :=
      Format('Estimated left: %s', [TicksToStr(
        ((CurTick - StartTick) / CurProgress) * (MaxProgress - CurProgress))]);
  end;
    PercentLabel.Caption :=
    Format('%.0f%%', [(CurProgress * 100.0) / MaxProgress]);
    ElapsedLabel.Caption := 
    Format('Elapsed: %s', [TicksToStr(CurTick - StartTick)]);
end;

// ------------ LifeCycle ------------

procedure InitializeWizard();
begin
    CreateCopyright;
    ModifyWizardSelectDirPage;
    ModifyWizardInstallingPage;                                 
end;