unit BeriMeritve;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFBeriMeritve = class(TForm)
    Panel1: TPanel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    function Izbira(bermer : Integer) : integer ;
  end;

var
  FBeriMeritve: TFBeriMeritve;

implementation

{$R *.dfm}

function TFBeriMeritve.Izbira(bermer : Integer) : integer ;
begin
  if berMer = 0 then RadioButton1.checked := true  else  RadioButton2.checked := true;
  ShowModal ;
  if modalResult = mrOk then
  begin
    if RadioButton1.checked then result := 0 else result := 1 ;
  end else result := 2 ;
end;

end.
