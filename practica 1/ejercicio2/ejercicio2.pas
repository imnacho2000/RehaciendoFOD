{
    Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
    creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
    el promedio de los números ingresados. El nombre del archivo a procesar debe ser
    proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
    contenido del archivo en pantalla.

}

program ejercicio2;
const
    archivo_ejercicio1 = 'C:\Users\ignac\OneDrive\Escritorio\rehaciendo fod\practica1\ejercicio1\ejercicio1';
type
    archivo_maestro = file of integer;

    procedure imprimir_maestro(var archivo: archivo_maestro);
    var
        numero:integer;
    begin
        reset(archivo);
        while not eof(archivo) do begin
            read(archivo,numero);
            writeln('Numero: ', numero);
        end;
        close(archivo);
    end;
var
    archivo: archivo_maestro;
begin
    Assign(archivo,archivo_ejercicio1);
    imprimir_maestro(archivo);
end.