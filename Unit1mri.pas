unit Unit1mri;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, CheckLst, tekSystem, tekWindows,
  tekClasses, Menus, XPMan;

type
  TForm1 = class(TForm)
    CheckListBox1: TCheckListBox;
    Panel1: TPanel;
    TreeView1: TTreeView;
    MainMenu1: TMainMenu;
    Menu1: TMenuItem;
    Exit1: TMenuItem;
    Splitter1: TSplitter;
    Timer1: TTimer;
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    LabeledEdit5: TLabeledEdit;
    LabeledEdit6: TLabeledEdit;
    LabeledEdit7: TLabeledEdit;
    LabeledEdit8: TLabeledEdit;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    ProgressBar1: TProgressBar;
    ListBox1: TListBox;
    Splitter2: TSplitter;
    Settings1: TMenuItem;
    Reset1: TMenuItem;
    Button3: TButton;
    Panel2: TPanel;
    Splitter3: TSplitter;
    LabeledEdit9: TLabeledEdit;
    LabeledEdit10: TLabeledEdit;
    LabeledEdit11: TLabeledEdit;
    LabeledEdit12: TLabeledEdit;
    procedure Exit1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckListBox1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure LabeledEdit4Change(Sender: TObject);
    procedure LabeledEdit3Change(Sender: TObject);
    procedure LabeledEdit8Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1KeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
  private
    procedure RefreshImageList;
    procedure RefreshTreeView;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure ShowTreeView;
    procedure ShowImagePresense;
    function ExtractNodePath(Value: TTreeNode): String;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1 = nil;
  MyImagesDirName: String = 'Images';
  MyImagesExtension: String = '.Image';
  MySetName: String = 'Settings.DIM.TEK';
  MyWorkDir: String = EmptyString;
  MyImagesList: TMyStringList = nil;
  CrntImage: TMyDiskImage = nil;
  CrntFileName: String = EmptyString;
  MyFStr: TMyFileStream = nil;
  StopSearch: Boolean = false;

implementation

{$R *.dfm}

uses Unit2Search;

procedure TForm1.CheckListBox1Click(Sender: TObject);
begin
CheckListBox1.Enabled:=false;
if CheckListBox1.Items.Count > Zero then
if CheckListBox1.ItemIndex > mOne then begin
CrntFileName:=MyImagesList.Line[CheckListBox1.ItemIndex];
RefreshTreeView; end;
CheckListBox1.Enabled:=true;
end;

procedure BuildTreeView(Value: TMyNode; Node: TTreeNode);
var a1:Cardinal;
begin
if Value.Count > Zero then
for a1:=Zero to Value.Max do
if Value.MyType = mnFileImage then
Form1.TreeView1.Items.AddChild(Node,Value.Items[a1].Name) else
if Value.MyType = mnFolderImage then
BuildTreeView(Value.Items[a1],Form1.TreeView1.Items.AddChild(Node,Value.Items[a1].Name)) else
if Value.MyType = mnDiskImage then
BuildTreeView(Value.Items[a1],Form1.TreeView1.Items.AddChild(Node,Value.Items[a1].Name));
end;

procedure TForm1.ShowTreeView;
var v2:TTreeNode;
begin
Panel1.Enabled:=false;
if Assigned(CrntImage) then begin
LabeledEdit1.Text:=CrntImage.Caption;
LabeledEdit2.Text:=EmptyString;
LabeledEdit3.Text:=CrntImage.Owner;
LabeledEdit4.Text:=CrntImage.Holder;
LabeledEdit5.Text:=IntToStr(CrntImage.SerialNumber);
LabeledEdit6.Text:=CrntImage.FileSystem;
LabeledEdit7.Text:=IntToStr(Round(CrntImage.Size/mnMB));
LabeledEdit8.Text:=CrntImage.CoverName;
Panel1.Enabled:=true;
TreeView1.Items.BeginUpdate;
TreeView1.Items.Clear;
v2:=TreeView1.Items.AddChild(nil,CrntImage.Name);
BuildTreeView(CrntImage,v2); end;
TreeView1.Items.EndUpdate;
end;

procedure TForm1.RefreshTreeView;
begin
if FileExists(CrntFileName) then
if CrntImage.ClearDestroyAll then
if CrntImage.LoadFromFile(CrntFileName) then
ShowTreeView;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
Close;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
//StatusBar1.SimpleText:=mDivOfCom+DateToStr(Date)+mDivOfCom+TimeToStr(Time);
end;

procedure TForm1.RefreshImageList;
var a1:Cardinal;
begin
CheckListBox1.Enabled:=false;
CheckListBox1.Items.BeginUpdate;
CheckListBox1.Items.Clear;
if MyImagesList.Scan(MyImagesExtension,MyWorkDir) then
for a1:=Zero to MyImagesList.Max do begin
CheckListBox1.Items.Add(ExtractFileNameOnly(MyImagesList.Line[a1]));
CheckListBox1.Checked[a1]:=true; end;
CheckListBox1.Items.EndUpdate;
CheckListBox1.Enabled:=true;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
MyWorkDir:=SetInAppPath(MyImagesDirName);
if not FileExists(MyWorkDir) then
if not CreateDirectory(PChar(MyWorkDir),nil) then
Halt;
MyFStr:=TMyFileStream.Create;
MySetName:=SlashSep(MyWorkDir,MySetName);
if FileExists(MySetName) then
LoadSettings;
MyImagesList:=TMyStringList.Create;
CrntImage:=TMyDiskImage.Create(EmptyString);
RefreshImageList;
ShowTreeView;
end;

procedure TForm1.LoadSettings;
var a1:Cardinal;
begin
if MyFStr.OpenRead(PChar(MySetName)) then begin
if MyFStr.Read(a1) then
Left:=a1;
if MyFStr.Read(a1) then
Top:=a1;
if MyFStr.Read(a1) then
Width:=a1;
if MyFStr.Read(a1) then
Height:=a1;
if MyFStr.Read(a1) then
CheckListBox1.Width:=a1;
if MyFStr.Read(a1) then
ListBox1.Height:=a1;
MyFStr.Read(mSb1);
MyFStr.Read(mSb2);
MyFStr.Read(mStrFindValue1);
MyFStr.Read(a1);
Panel2.Width:=a1;
MyFStr.Close; end;
end;

procedure TForm1.SaveSettings;
var a1:Cardinal; b1:Boolean;
begin
if MyFStr.OpenWrite(PChar(MySetName)) then begin
a1:=Left;
MyFStr.Write(a1);
a1:=Top;
MyFStr.Write(a1);
a1:=Width;
MyFStr.Write(a1);
a1:=Height;
MyFStr.Write(a1);
a1:=CheckListBox1.Width;
MyFStr.Write(a1);
a1:=ListBox1.Height;
MyFStr.Write(a1);
b1:=Form2.CheckBox1.Checked;
MyFStr.Write(b1);
b1:=Form2.CheckBox2.Checked;
MyFStr.Write(b1);
MyFStr.Write(Form2.Edit1.Text);
a1:=Panel2.Width;
MyFStr.Write(a1);
MyFStr.Close; end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
SaveSettings;
MyFStr.Destroy;
MyImagesList.Destroy;
if CrntImage <> nil then
CrntImage.Destroy;
end;

procedure TForm1.Reset1Click(Sender: TObject);
begin
Width:=800;
Height:=447;
Position:=poScreenCenter;
ListBox1.Height:=24;
CheckListBox1.Width:=185;
end;

procedure TForm1.ShowImagePresense;
begin
if FileExists(CrntFileName) then
Edit1.Font.Color:=clGreen else
Edit1.Font.Color:=clRed;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
Button1.Enabled:=false;
if Assigned(CrntImage) then begin
CrntImage.ClearDestroyAll;
CrntImage.Destroy;
CrntImage:=nil; end;
CrntImage:=TMyDiskImage.Create(Edit1.Text[One]);
ShowTreeView;
LabeledEdit8.Text:=LabeledEdit1.Text;
CrntFileName:=SlashSep(MyWorkDir,LabeledEdit8.Text)+MyImagesExtension;
ShowImagePresense;
Button1.Enabled:=true;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
Button2.Enabled:=false;
if CrntFileName <> EmptyString then
if Assigned(CrntImage) then
CrntImage.SaveToFile(CrntFileName);
ShowImagePresense;
RefreshImageList;
Button2.Enabled:=true;
end;

procedure TForm1.LabeledEdit4Change(Sender: TObject);
begin
if Assigned(CrntImage) then
CrntImage.Holder:=LabeledEdit4.Text;
end;

procedure TForm1.LabeledEdit3Change(Sender: TObject);
begin
if Assigned(CrntImage) then
CrntImage.Owner:=LabeledEdit3.Text;
end;

procedure TForm1.LabeledEdit8Change(Sender: TObject);
begin
if Assigned(CrntImage) then
CrntImage.CoverName:=LabeledEdit8.Text;
end;

function TForm1.ExtractNodePath(Value: TTreeNode): String;
var v1:TTreeNode;
begin
Result:=EmptyString;
if Assigned(Value) then begin
v1:=Value.Parent;
while not v1.IsFirstNode do begin
Result:=v1.Text+mnSlash+Result;
v1:=v1.Parent; end;
Result:=Result+Value.Text; end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var a1,a2:Cardinal; s1:String;
begin
Form2.Position:=poScreenCenter;
Form2.ShowModal;
ListBox1.SetFocus;
if sRes then
if Length(Form2.Edit1.Text) > Zero then begin
s1:=Form2.Edit1.Text;
Panel1.Enabled:=false;
CheckListBox1.Enabled:=false;
ListBox1.Items.Clear;
ProgressBar1.Min:=Zero;
ProgressBar1.Max:=CheckListBox1.Items.Count-One;
ProgressBar1.Position:=Zero;
for a1:=ProgressBar1.Min to ProgressBar1.Max do begin
CrntFileName:=MyImagesList.Line[a1];
RefreshTreeView;
if TreeView1.Items.Count > Zero then
for a2:=Zero to TreeView1.Items.Count-One do
if Pos(UpperCase(s1),UpperCase(TreeView1.Items[a2].Text)) > Zero then begin
ListBox1.Items.Add(CheckListBox1.Items[a1]+mnArrowLine+ExtractNodePath(TreeView1.Items[a2]));
if Form2.CheckBox1.Checked or StopSearch then
Break;
Application.ProcessMessages; end;
if Form2.CheckBox1.Checked or StopSearch then
if (ListBox1.Items.Count > Zero) or StopSearch then
Break;
Application.ProcessMessages;
ProgressBar1.Position:=a1;
ListBox1.Refresh; end;
CheckListBox1.Enabled:=true;
Panel1.Enabled:=true;
ProgressBar1.Position:=Zero;
if Form2.CheckBox2.Checked then
for a1:=Zero to Ten do
Windows.Beep(1900+a1*50,Twelve);
StopSearch:=false; end;
end;

procedure TForm1.ListBox1Click(Sender: TObject);
var s1,s2,s3,s4:String; a1:Integer; a2,a3:Cardinal;
begin
if ListBox1.Items.Count > Zero then
if ListBox1.ItemIndex > mOne then begin
ListBox1.Enabled:=false;
s1:=ListBox1.Items[ListBox1.ItemIndex];
a1:=Pos(mnArrowLine,s1)-One;
if a1 > Zero then begin
s2:=Copy(s1,One,Pos(mnArrowLine,s1)-One);
s4:=Copy(s1,Pos(mnArrowLine,s1)+Length(mnArrowLine),Length(s1)-a1);
s3:=ExtractFileName(s4);
if CheckListBox1.Items.Count > Zero then
for a2:=Zero to CheckListBox1.Items.Count-One do
if CheckListBox1.Items[a2] = s2 then begin
CheckListBox1.ItemIndex:=a2;
CheckListBox1Click(Self);
if TreeView1.Items.Count > Zero then
for a3:=Zero to TreeView1.Items.Count-One do
if TreeView1.Items[a3].Text = s3 then begin
TreeView1.Items[a3].Selected:=true;
if ExtractNodePath(TreeView1.Selected) = s4 then begin
TreeView1.Refresh;
TreeView1.SetFocus;
Break; end; end; end; end;
ListBox1.Enabled:=true; end;
end;

procedure TForm1.ListBox1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
if Key = vk_Escape then
StopSearch:=true;
end;

end.
