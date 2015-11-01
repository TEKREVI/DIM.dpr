unit Unit2Search;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, tekSystem;

type
  TForm2 = class(TForm)
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Button1: TButton;
    Button2: TButton;
    CheckBox2: TCheckBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2 = nil;
  sRes: Boolean = false;
  mSb1,mSb2: Boolean;
  mStrFindValue1: String = MainExt;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
sRes:=true;
Close;
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
sRes:=false;
Close;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
CheckBox1.Checked:=mSb1;
CheckBox2.Checked:=mSb2;
Edit1.Text:=mStrFindValue1;
end;

procedure TForm2.Edit1KeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
if Key = _13 then
Button1Click(Self) else
if Key = vk_Escape then
Button2Click(Self)
end;

end.
