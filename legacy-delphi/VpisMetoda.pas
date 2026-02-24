unit VpisMetoda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,postaje;

type
  TFvpismetoda = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Combo1: TComboBox;
    Edit1: TEdit;
    Button1: TButton;
    Label3: TLabel;
    Edit2: TEdit;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure vpis ;
  end;

var
  Fvpismetoda: TFvpismetoda;

implementation

{$R *.dfm}

uses metode;

procedure TFvpismetoda.Button1Click(Sender: TObject);
  var idp : integer ;
      mp : string ;
      kan : integer ;
      op : string ;
begin
  idp := Fpostaje.Getpost ;
  mp := Combo1.Text ;
  kan := StrToInt(edit1.Text) ;
  op := edit2.Text ;
  FMetode.Zapis(idp,kan,mp,op)  ;
  combo1.Text := '' ;
  edit1.Text := '' ;
end;

procedure TFVpismetoda.vpis ;
begin
  ShowModal ;
end;

end.
