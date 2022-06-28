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