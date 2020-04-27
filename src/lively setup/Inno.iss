﻿; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Lively Wallpaper"
#define MyAppVersion "0.9.5.5"
#define MyAppPublisher "rocksdanister"
#define MyAppURL "https://github.com/rocksdanister/lively"
#define MyAppExeName "livelywpf.exe"

[CustomMessages]
; This is all machine translated...might be gibberish!
english.RunAtStartup=Start with Windows
chinese.RunAtStartup=从Windows开始
japanese.RunAtStartup=窓から始める
russian.RunAtStartup=начать с Windows
spanish.RunAtStartup=Iniciar Windows

english.FullInstall=Full
chinese.FullInstall=充分
japanese.FullInstall=一杯
russian.FullInstall=полный
spanish.FullInstall=llena

english.LiteInstall=Lite
chinese.LiteInstall=精简版
japanese.LiteInstall=ライト
russian.LiteInstall=облегченная
spanish.LiteInstall=lite

english.CustomInstall=Custom
chinese.CustomInstall=习俗
japanese.CustomInstall=カスタム
russian.CustomInstall=обычай
spanish.CustomInstall=personalizada

english.DeleteEverythigMsgBox=Do you want to delete userdata & wallpapers in
chinese.DeleteEverythigMsgBox=您要删除用户数据和墙纸吗
japanese.DeleteEverythigMsgBox=ユーザーデータと壁紙を削除しますか
russian.DeleteEverythigMsgBox=Вы хотите удалить пользовательские данные и обои
spanish.DeleteEverythigMsgBox=¿Desea eliminar datos de usuario y fondos de pantalla en

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{E3E43E1B-DEC8-44BF-84A6-243DBA3F2CB1}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
; Remove the following line to run in administrative install mode (install for all users.)
; lowest - AppData folder, admin - Program Files (x86) 
PrivilegesRequired=lowest
; Ask user which PrivilegesRequired on startup.
PrivilegesRequiredOverridesAllowed=dialog
OutputBaseFilename=lively_installer
SetupIconFile=Icons\icons8-seed-of-life-96-normal.ico
Compression=lzma
;Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
;Installer/Uninstaller will stop if application is running by checking mutex.
AppMutex=LIVELY:DESKTOPWALLPAPERSYSTEM
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"; LicenseFile: "License\License.txt";
Name: "chinese"; MessagesFile: "Setup Languages\ChineseSimplified.isl"
Name: "japanese"; MessagesFile: "compiler:Languages\Japanese.isl";
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl";
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl";

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; 
;GroupDescription: "{cm:AdditionalIcons}"
Name: "windowsstartup";Description: "{cm:RunAtStartup}" 

[Registry]
;current user only
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "livelywpf"; ValueData: "{app}\livelywpf.exe"; Flags: uninsdeletekey; Tasks:windowsstartup

;[UninstallDelete]

[Types]
Name: "full"; Description: "{cm:FullInstall}"
Name: "lite"; Description: "{cm:LiteInstall}"
Name: "custom"; Description: "{cm:CustomInstall}"; Flags: iscustom

[Components]
Name: "program"; Description: "Program Files"; Types: full lite custom; Flags: fixed
Name: "cef"; Description: "Web Wallpaper Support"; Types: full
Name: "wallpapers"; Description: "Sample Wallpapers"; Types: full

[Files]
Source: "VC\VC_redist.x86.exe"; DestDir: {tmp}; Flags: deleteafterinstall

; NOTE: Don't use "Flags: ignoreversion" on any shared system files
Source: "Release\livelywpf.exe"; DestDir: "{app}"; Flags: ignoreversion;Components: program
Source: "Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: program
Source: "Lively Wallpaper\external\cef\*"; DestDir: "{userdocs}\Lively Wallpaper\external\cef"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: cef
Source: "Lively Wallpaper\wallpapers\*"; DestDir: "{userdocs}\Lively Wallpaper\wallpapers"; Flags: ignoreversion recursesubdirs createallsubdirs onlyifdoesntexist uninsneveruninstall; Components: wallpapers; Check: ShouldInstallWallpapers
; pushing new set of wp's with customisation to existing users (v0.8 only), shouldInstallWallpaper check will be added from later version onwards..
Source: "Lively Wallpaper\wallpapers new\*"; DestDir: "{userdocs}\Lively Wallpaper\wallpapers"; Flags: ignoreversion recursesubdirs createallsubdirs onlyifdoesntexist uninsneveruninstall; Components: wallpapers; Check: ShouldInstallWallpapers

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall 
;skipifsilent
Filename: "{tmp}\VC_redist.x86.exe"; Check: VCRedistNeedsInstall; StatusMsg: Installing Visual Studio Runtime Libraries...

[Code]
var
  isAlreadyInstalled: Boolean;

// Visual C++ redistributive component install.
//ref: https://bell0bytes.eu/inno-setup-vc/
type
  INSTALLSTATE = Longint;

  const
  INSTALLSTATE_INVALIDARG = -2;  { An invalid parameter was passed to the function. }
  INSTALLSTATE_UNKNOWN = -1;     { The product is neither advertised or installed. }
  INSTALLSTATE_ADVERTISED = 1;   { The product is advertised but not installed. }
  INSTALLSTATE_ABSENT = 2;       { The product is installed for a different user. }
  INSTALLSTATE_DEFAULT = 5;      { The product is installed for the current user. }

#IFDEF UNICODE
  #DEFINE AW "W"
#ELSE
  #DEFINE AW "A"
#ENDIF

{ Visual C++ 2019 v14, the included installer is a bundle consisting of older vers }
VC_2019_REDIST_X86_MIN = '{2E72FA1F-BADB-4337-B8AE-F7C17EC57D1D}';

function MsiQueryProductState(szProduct: string): INSTALLSTATE; 
  external 'MsiQueryProductState{#AW}@msi.dll stdcall';

function VCVersionInstalled(const ProductID: string): Boolean;
begin
  Result := MsiQueryProductState(ProductID) = INSTALLSTATE_DEFAULT;
end;

function VCRedistNeedsInstall: Boolean;
begin
  Result := not VCVersionInstalled(VC_2019_REDIST_X86_MIN);
end;


// event fired when the uninstall step is changed: https://stackoverflow.com/revisions/12645836/1
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  // if we reached the post uninstall step (uninstall succeeded), then...
  if CurUninstallStep = usPostUninstall then
  begin
    // query user to confirm deletion; if user chose "Yes", then...
    if SuppressibleMsgBox(ExpandConstant('{cm:DeleteEverythigMsgBox}')+' '+ ExpandConstant('{userdocs}\Lively Wallpaper') + ' ?',
      mbConfirmation, MB_YESNO, IDNO) = IDYES
    then
      // deletion confirmed by user.
      begin
        // Delete the directory Documents/LivelyWallpaper and everything inside it
        DelTree(ExpandConstant('{userdocs}\Lively Wallpaper'), True, True, True);
      end;
  end;
end;

//Uninstall previous install: https://stackoverflow.com/questions/2000296/inno-setup-how-to-automatically-uninstall-previous-installed-version
//note: Inno does not delete files, it just overwrites & keeps the old ones if they have different name..it can get accumulated/confusing when program structure change?!
function GetUninstallString(): String;
var
  sUnInstPath: String;
  sUnInstallString: String;
begin
  sUnInstPath := ExpandConstant('Software\Microsoft\Windows\CurrentVersion\Uninstall\{#emit SetupSetting("AppId")}_is1');
  sUnInstallString := '';
  if not RegQueryStringValue(HKLM, sUnInstPath, 'UninstallString', sUnInstallString) then
    RegQueryStringValue(HKCU, sUnInstPath, 'UninstallString', sUnInstallString);
  Result := sUnInstallString;
end;


/////////////////////////////////////////////////////////////////////
function IsUpgrade(): Boolean;
begin
  Result := (GetUninstallString() <> '');
end;


/////////////////////////////////////////////////////////////////////
function UnInstallOldVersion(): Integer;
var
  sUnInstallString: String;
  iResultCode: Integer;
begin
// Return Values:
// 1 - uninstall string is empty
// 2 - error executing the UnInstallString
// 3 - successfully executed the UnInstallString

  // default return value
  Result := 0;
  // get the uninstall string of the old app
  sUnInstallString := GetUninstallString();
  if sUnInstallString <> '' then begin
    sUnInstallString := RemoveQuotes(sUnInstallString);
    if Exec(sUnInstallString, '/VERYSILENT /NORESTART /SUPPRESSMSGBOXES','', SW_HIDE, ewWaitUntilTerminated, iResultCode) then
      begin
        isAlreadyInstalled := True;
        Result := 3;
      end
    else
      begin
      isAlreadyInstalled := True;
      Result := 2;
      end
  end else
    isAlreadyInstalled := False;
    Result := 1;
end;

/////////////////////////////////////////////////////////////////////
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep=ssInstall) then
  begin
    if (IsUpgrade()) then
    begin
      UnInstallOldVersion();
    end;
  end;
end;

function ShouldInstallWallpapers: Boolean;
begin
    Result := not isAlreadyInstalled;
end;
