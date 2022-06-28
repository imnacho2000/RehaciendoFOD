{
    Dada la siguiente estructura:
                type
                reg_flor = record
                nombre: String[45];
                codigo:integer;
                tArchFlores = file of reg_flor;

    Las bajas se realizan apilando registros borrados y las altas reutilizando registros
    borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
    número 0 en el campo código implica que no hay registros borrados y -N indica que el
    próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
    a. Implemente el siguiente módulo:
    {Abre el archivo y agrega una flor, recibida como parámetro
    manteniendo la política descripta anteriormente}
    // procedure agregarFlor (var a: tArchFlores ; nombre: string;
    // codigo:integer);
    // b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
    // considere necesario para obtener el listado.


    // 5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
    {Abre el archivo y elimina la flor recibida como parámetro manteniendo
    la política descripta anteriormente}
    // procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);

}

program ejercicio;
const
    valor_alto = 9999;
type

    reg_flor = record
        nombre: string[45];
        codigo: integer;
    end;

    tArchFlores = file of reg_flor;

    procedure agregar(var m: tArchFlores; nombre: string; codigo: integer);
    var
        aux,regM: reg_flor;
    begin
        aux.nombre := nombre;
        aux.codigo := codigo;
        reset(m);
        read(m,regM);
        if (regM.codigo > 0) then begin
            seek(m,Abs(regM.codigo));
            read(m,regM);
            seek(m,filepos(m)-1);
            write(m,aux);
            seek(m,0);
            write(m,regM);
        end
        else begin
            seek(m,filesize(m));
            write(m,aux);
        end;
    end;

    procedure listado(var m: tArchFlores);
    var
        regM: reg_flor;
    begin
        reset(m);
        while not eof(m) do begin
            read(m,regM);
            if (regM.codgio > 0 ) then
                 writeln('Flor: ', regm.nombre, ' Codigo ', regm.codigo,'.');
        end;
        close(m);
    end;

    procedure eliminarFlor(var m: tArchFlores; flor:reg_flor);
    var
        regM: reg_flor;
        cabecera: integer;
    begin
        reset(m);
        read(m,regM);
        cabecera := regM.codigo;
        while(regM.codigo <> flor.codigo) do
            read(m,regM);
        if(regM.codigo = flor.codigo) then begin
            regM.codigo := cabecera;
            cabecera:= (filepos(m) * -1);
            seek(m,filepos(m) - 1);
            write(m,regM);
            regM.codigo:= cabecera;
            seek(m,0);
            write(m,regM);
        end
        else
            writeln('La flor no se encontro.');
        close(m);
    end;

var

begin

end.
