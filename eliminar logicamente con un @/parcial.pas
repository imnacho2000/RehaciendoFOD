{
    Definir un programa que genere un archivo con registros de longitud fija conteniendo
    información de asistentes a un congreso a partir de la información obtenida por
    teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
    nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
    archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
    asistente inferior a 1000.
    Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
    String a su elección. Ejemplo: ‘@Saldaño’.

}

program parcial;
const
    valor_alto = 1000;
type
    asistente = record
        nro: integer;
        apellidoNombre: string[25];
        email: string[25];
        telefono: integer;
        dni: string[10];
    end;

    maestro = file of asistente;

    procedure eliminar(var m:maestro);
    var
        regM: asistente;
    begin
        reset(m);
        read(m,regM);
        while not eof(m) do begin
            if(regM.nro < 1000) then
                regM.apellidoNombre := '@' + regM.apellidoNombre;
            read(m,regM)
        end;
        close(m);
    end;

var

begin

end.