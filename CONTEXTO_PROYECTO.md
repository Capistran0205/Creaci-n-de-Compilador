# Contexto del proyecto: Compilador de **Infinix**

Compilador **didáctico** (proyecto NetBeans / Java + Swing) para un lenguaje propio
llamado **Infinix**. Implementa las fases de análisis **léxico**, **sintáctico** y
**semántico**, con visualización del **Árbol de Análisis Sintáctico (AAS)**. Aún no
genera código intermedio.

> Las marcas **🆕** señalan la funcionalidad integrada recientemente:
> **fase semántica**, **potencia `^`** y **menos unario (números negativos)**.

## Arquitectura por paquetes

| Paquete (carpeta) | Rol |
|---|---|
| `src/AnalizadorLexico/app/com/` | Léxico para la interfaz: `Lexico.flex` → `AnalizadorLexico.java`. Devuelve el enum `Token` (incluye `POT` y `LINEA`) y expone el lexema en el campo público `lexeme`. Apoyado por `Token` y `Categoria`. |
| `src/AnalizadorSintactico/app/com/` | Sintáctico CUP: `LexerCup.flex` (modo `%cup`, emite `Symbol`) + `Sintactico.cup` → `Sintactico.java` y `sym.java`. |
| `src/AnalizadorSemantico/app/com/` | 🆕 **Fase semántica:** `Tipo` (enum de tipos), `Simbolo`, `TablaSimbolos` (ámbito único global) y `AnalizadorSemantico` (recorre el árbol, construye la tabla de símbolos y verifica tipos/declaraciones con **promoción numérica**). |
| `src/AAS/app/com/` | Árbol sintáctico: `Nodo` (recursivo; 🆕 enriquecido con `linea`, `columna`, `tipoToken` y `tipo` para la fase semántica), `ArbolJGrapht` (lo pasa a un grafo dirigido de **JGraphT**) y `VisualizadorArbol` (lo dibuja con **JGraphX/mxGraph**). |
| `src/Compilador/app/com/` | `InterfazCompilador` (JFrame principal), `Main` (generador de analizadores) y las `Librerias/` (JFlex, java-cup, jgrapht, jgraphx). |
| `src/CodigosFuenteInfinix/app/com/` | Ejemplos: `CodigoLimpio.txt` (válido) y `CodigoErroneo.txt` (con errores para probar el modo pánico). |

## El lenguaje Infinix

- **Tipos de dato:** `entero`, `decimal`, `caracter`, `cadena`, `booleano`
- **Booleanos:** `verdadero`, `falso` (clasificados como LITERAL)
- **E/S:** `mt < ... >` (salida / print) e `inp < id >` (entrada)
- **Operadores:** `+ - * / ^` (🆕 `^` potencia) y 🆕 **menos unario** (números negativos); **símbolos:** `=`, `,`, `<`, `>`, `(`, `)`, `'`
- **Fin de instrucción:** el token `:_:` (cada sentencia termina así)
- **Literales:** número `digitos(.digitos)?`, cadena delimitada por `@...@`, carácter `'c'`
- **Comentarios:** de una línea con `#` (estilo Python) y multilínea `/* */`
- **Gramática (CUP):** `programa → instruccion*`; instrucciones de **declaración**
  (con lista separada por comas e inicialización opcional), **asignación**, **salida**
  y **entrada**.
- 🆕 **Expresiones:** gramática ambigua resuelta por **precedencias** (de menor a mayor):
  `+ -` < `* /` < **menos unario** < `^`. La potencia `^` y el menos unario asocian por
  la derecha, de modo que `-2^2 = -(2^2)` y `2^3^2 = 2^(3^2)`.

### Ejemplo válido (`CodigoLimpio.txt`)

```
entero contador = 0, limite = 10 :_:
decimal promedio = 85.5 :_:
cadena mensaje = @Resultado final@ :_:
caracter grado = 'B' :_:
booleano aprobado = verdadero :_:
contador = (limite - 2) * 3 + 1 / 2 :_:
mt < mensaje, promedio, grado > :_:
inp < contador > :_:
```

## Flujo de trabajo

1. Se ejecuta `Main.java`: corre **JFlex** sobre los `.flex` y **CUP** sobre el `.cup`,
   y **reubica** `sym.java` / `Sintactico.java` en su paquete (porque CUP los escribe
   en la raíz del proyecto). La constante `BASE` apunta a la ruta local del proyecto.
2. Se reconstruye el proyecto en NetBeans (**Clean and Build**).
3. En `InterfazCompilador` el usuario carga/edita código y pulsa:
   - **Analizador Léxico** → vuelca los tokens a una tabla (Token / Lexema / Patrón),
     marcando errores con su línea.
   - **Analizador Sintáctico** → corre el parser; si hay errores los lista numerados con
     sugerencias; si es correcto, **abre la ventana del árbol** (AAS).
   - 🆕 **Analizador Semántico** → reparsea y, si la sintaxis es válida, corre la fase
     semántica; muestra errores de tipo/declaración numerados (o el mensaje de éxito),
     más **advertencias** de "uso sin inicializar". Se invoca con el método
     `analizarSemantica()` enlazado al botón.

## Características destacadas

- 🆕 **Fase semántica** (`AnalizadorSemantico`): tabla de símbolos (ámbito global),
  detección de variables **no declaradas** y **redeclaradas**, verificación de tipos en
  asignaciones y expresiones con **promoción numérica** (`entero`→`decimal`; `decimal`→
  `entero` es error), reglas para `^` y menos unario (operandos numéricos), y separación
  entre **errores** (bloquean) y **avisos** (no bloquean), todos con número de línea.
- **Manejo de errores sintácticos elaborado** (`Sintactico.cup`): recuperación en modo
  pánico (`error FIN_LINEA`), recolección de **todos** los errores y un sistema de
  **sugerencias contextuales** (falta coma, falta `:_:`, identificador inválido,
  paréntesis sin cerrar…) que usa reflexión sobre `sym` para saber qué terminales se
  esperaban en cada estado.
- **Resaltado de sintaxis** en vivo en el editor (regex por categorías, evitando
  colorear contenido dentro de cadenas / caracteres).
- **Visualización del AAS** con JGraphT + JGraphX en layout jerárquico interactivo
  (zoom y desplazamiento).

## Stack tecnológico

- **Java + Swing** (NetBeans, AbsoluteLayout).
- **JFlex 1.4.3** — generación de analizadores léxicos.
- **CUP 0.11b** — generación del analizador sintáctico LALR.
- **JGraphT 1.5.2** — modelo de grafo del árbol sintáctico.
- **JGraphX (mxGraph) 4.2.2** — render visual del árbol.
