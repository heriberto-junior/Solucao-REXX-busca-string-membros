# [EN] Solucao-REXX-busca-string-membros

A JCL and REXX solution that iterates through all members of a partitioned dataset, identifies specific string occurrences within each member, and writes the consolidated result to an output file.

## JCL

The JCL for this solution has two steps.  
In the first step, a complete member listing of the PDS `PRINC.LIB.SOURCE` is generated, with a structure similar to:
```
    READY
      LISTDS 'PRINC.LIB.SOURCE' MEMBERS
    PRINC.LIB.SOURCE
    --RECFM-LRECL-BLKSIZE-DSORG
      FB    80    27920   PO

    --VOLUMES--
      INTT03
    --MEMBERS--
      ABCARTEP
      ABCC0506
      ABCC0507
      ABCDI900
      ABCDI901
      ABCFF005
      ...
    READY
    END
```
Note: The `...` before READY contains all members of the partitioned dataset.

The second step executes the REXX member `LISTMEMB`, located in `LIBPRINC.LIB.REXX`, which is responsible for reading each listed member and applying the extraction rules.

---

## REXX

The REXX `LISTMEMB` opens each member of the PDS and checks two conditions:

1. Whether the string **GRVTM exists in columns 2 through 6**.
2. Whether the line falls within blocks delimited by:
   - `INCLUDE-PARM-FUN` / `END-INCLUDE`
   - `EXCLUDE-PARM-FUN` / `END-EXCLUDE`

If either condition is met, the line is written to the output dataset `<USER>.GRVT.RESULT`, along with the name of the member it belongs to.

---
---

# [PT-BR] Solucao-REXX-busca-string-membros

Solução em JCL e REXX que percorre todos os membros de um dataset particionado, identifica ocorrências específicas dentro de cada membro e grava o resultado consolidado em um arquivo de saída.

## JCL

O JCL desta solução possui dois steps.  
No primeiro step, é gerada uma listagem completa dos membros do PDS `PRINC.LIB.SOURCE`, com estrutura semelhante a:
```
    READY
      LISTDS 'PRINC.LIB.SOURCE' MEMBERS
    PRINC.LIB.SOURCE
    --RECFM-LRECL-BLKSIZE-DSORG
      FB    80    27920   PO

    --VOLUMES--
      INTT03
    --MEMBERS--
      ABCARTEP
      ABCC0506
      ABCC0507
      ABCDI900
      ABCDI901
      ABCFF005
      ...
    READY
    END
```
PS: O '...' antes de READY contém todos os membros do particionado.

O segundo step executa o membro REXX `LISTMEMB`, localizado em `LIBPRINC.LIB.REXX`, responsável por ler cada membro listado e aplicar as regras de extração.

---

## REXX

O REXX `LISTMEMB` abre cada membro do PDS e verifica duas condições:

1.  Se existe a string **GRVTM nas colunas 2 a 6**.
2.  Se a linha está dentro de blocos delimitados por:
    *   `INCLUDE-PARM-FUN` / `END-INCLUDE`
    *   `EXCLUDE-PARM-FUN` / `END-EXCLUDE`

Caso alguma condição seja atendida, a linha é registrada no dataset de saída `<USER>.GRVT.RESULT`, junto com o nome do membro ao qual pertence.
