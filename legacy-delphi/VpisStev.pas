unit VpisStev;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls;

type
  TFvpisStev = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Panel2: TPanel;
    Button1: TButton;
  private
    { Private declarations }
  public
    function Vpis(nas,lab : string; vl : integer) : integer ;
  end;

var
  FvpisStev: TFvpisStev;

implementation

{$R *.dfm}

function TFvpisStev.Vpis(nas,lab : string; vl : integer) : integer ;
begin
  caption := nas ;
  label1.Caption := lab ;
  Spinedit1.Value := vl ;
  ShowModal ;
  result := spinedit1.Value ;
end;

end.
