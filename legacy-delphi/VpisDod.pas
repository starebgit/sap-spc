unit VpisDod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFVpisDod = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    Function Vpis : string ;
  end;

var
  FVpisDod: TFVpisDod;

implementation

{$R *.dfm}

Function TFVpisDod.vpis : string ;
begin
  ShowModal ;
  if modalResult = MrOK then result := edit1.text
                        else result := '' ;
end;

end.
