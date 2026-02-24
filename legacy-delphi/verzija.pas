unit verzija;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFverzija = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
  private
    { Private declarations }
  public
    Procedure pokazi ;
  end;

var
  Fverzija: TFverzija;

implementation

{$R *.dfm}

Procedure TFverzija.pokazi ;
begin
  panel1.Color := $02DEDAC0 ;
  ShowModal
end;

end.
