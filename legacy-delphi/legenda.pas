unit legenda;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TFlegenda = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    Panel3: TPanel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
  private
    { Private declarations }
  public
    Procedure prikaz(op : integer) ;
  end;

var
  Flegenda: TFlegenda;

implementation

{$R *.dfm}

Procedure Tflegenda.prikaz(op : integer) ;
begin
  label3.Caption := 'Stroj naj se nemudoma zaustavi!' + chr(13) + 'Izvede naj se ustrezni ukrep in ponovna meritev' ;
  label4.Caption := 'Stroj lahko nadaljuje s delom.' + chr(13) + 'Izvede naj se ustrezni ukrep in ponovna meritev' ;
  label5.Caption := 'Stroj lahko nadaljuje s delom.' ;
  label6.Caption := 'Stroj naj se nemudoma zaustavi!' + chr(13) + 'Izvede naj se ustrezni ukrep in ponovna meritev' ;
  label7.Caption := 'Stroj lahko nadaljuje s delom.' ;
   edit1.text := 'Izven tolerance' ;
    edit2.text := 'Izven kontrolnih meja' ;
    edit3.text := 'Normalna meritev' ;
    edit2.Color := clYellow ;
    edit3.Visible := true ;

    edit4.Text := 'Število slabih' ;
    edit5.Text := 'Vsi dobri' ;



  showModal ;
end;

end.
