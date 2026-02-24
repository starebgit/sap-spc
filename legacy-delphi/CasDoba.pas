unit CasDoba;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFcasDoba = class(TForm)
    Panel1: TPanel;
    Picker1: TDateTimePicker;
    Picker2: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
  private
    { Private declarations }
  public
    Procedure Vpis(var dat1,dat2 : string );
  end;

var
  FcasDoba: TFcasDoba;

implementation

{$R *.dfm}


Procedure TfcasDoba.Vpis(var dat1,dat2 : string );
begin
  showModal ;
  dat1 := dateTostr(picker1.date) ;
  dat2 := dateTostr(picker2.date) ;
end;

end.
