unit VpisPrijava;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, deklar;

type
  TFVpisPrijava = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    Label7: TLabel;
    Edit7: TEdit;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    Label8: TLabel;
    CheckBox1: TCheckBox;
  private
    { Private declarations }
  public
    procedure Vpis(var prija  : Tprijava) ;
  end;

var
  FVpisPrijava: TFVpisPrijava;

implementation

{$R *.dfm}

procedure TFVpisprijava.Vpis(var prija  : Tprijava) ;
begin
  showModal ;
   with prija do
   begin
     if ModalResult = mrOK then
     begin
      sistem := edit1.Text ;
      cli := edit2.Text ;
      applic := edit3.Text ;
      sisnum := StrToIntDef(edit4.Text,0) ;
      upo := edit5.Text ;
      ges := edit6.Text ;
      jezik := edit7.Text ;
     def := checkBox1.Checked ;
    end else sistem := ''  ;
  end ;
end;



end.
