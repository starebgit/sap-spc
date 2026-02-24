unit Vpismerila;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFvpismerila = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Button1: TButton;
    Button2: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit3Enter(Sender: TObject);
    procedure Edit4Enter(Sender: TObject);
  private
    { Private declarations }
  public
   procedure vpis(var red : integer; var stev,naziv,opis : string) ;
  end;

var
  Fvpismerila: TFvpismerila;

implementation

{$R *.dfm}



procedure TFvpismerila.Button1Click(Sender: TObject);
  var bb : boolean ;
begin
  ModalResult := mrNone ;
  if edit2.Text = '' then
  begin
    label5.visible := True ;
    exit ;
  end;
  if edit3.Text = '' then
  begin
    label6.visible := True ;
    exit ;
  end;
  if edit4.Text = '' then
  begin
    label7.visible := True ;
    exit ;
  end;
 // bb  := (edit2.Text <> '') and (edit3.Text <> '') and (edit4.Text <> '')  ;
  ModalResult := mrOk  ;

end;

procedure TFvpismerila.Edit2Enter(Sender: TObject);
begin
  label5.Visible := false ;
end;

procedure TFvpismerila.Edit3Enter(Sender: TObject);
begin
  label6.Visible := false ;
end;


procedure TFvpismerila.Edit4Enter(Sender: TObject);
begin
  label7.Visible := false ;
end;

procedure TFvpisMerila.vpis(var red : integer; var stev,naziv,opis : string) ;

begin
  edit1.text := intTostr(red+1) ;
  edit2.Text := '' ;
  edit3.Text := '' ;
  edit4.Text := '' ;
  panel2.Color := $02DEDAC0 ;
  ShowModal ;

  if modalResult = mrOk then
  begin
    red := strToIntDef(edit1.Text,1) ;
    stev := edit2.Text ;
    naziv := edit3.Text ;
    opis := edit4.Text ;
  end else red := 0 ;
end;

end.
