unit defKanal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ExtCtrls;

type
  TFdefkanal = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    SpinEdit1: TSpinEdit;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
    Function Vpiskan(vl : integer) : integer ;
  end;

var
  Fdefkanal: TFdefkanal;

implementation

{$R *.dfm}

Function TfDefKanal.Vpiskan(vl : integer) : integer ;
begin
  SpinEdit1.value := vl ;
  ShowModal ;
  if modalresult = mrOk then result := spinedit1.Value else result := 0 ;

end;

end.
