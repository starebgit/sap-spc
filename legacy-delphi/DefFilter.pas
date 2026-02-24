unit DefFilter;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TFDefFilter = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    Picker1: TDateTimePicker;
    Picker2: TDateTimePicker;
    Label2: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Label4: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
  private
    { Private declarations }
  public
   function Vpis(var dat1,dat2 : TdateTime; var kd,srz : string) : boolean ;

  end;

var
  FDefFilter: TFDefFilter;

implementation

{$R *.dfm}

function TFDefFilter.Vpis(var dat1,dat2 : TdateTime; var kd,srz : string) : boolean;
begin
  picker1.Date := date-1 ;
  picker2.Date := date ;
  edit1.text := kd ;
  edit2.text := srz ;
  ShowModal ;
  if modalResult = mrOk then
  begin
    dat1 := picker1.date ;
    dat2 := picker2.Date + 1;
    kd := trim(edit1.Text) ;
    srz := trim(edit2.Text) ;
    result := true ;
  end else result := false ;
end;
end.
