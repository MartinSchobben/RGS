# Sever output based on figure selection

    Code
      output$reference
    Output
      [1] "<table  class = 'table shiny-table table- spacing-s' style = 'width:auto;'>\n<thead> <tr> <th style='text-align: left;'> 1 </th> <th style='text-align: left;'> 2 </th> <th style='text-align: left;'> 3 </th> <th style='text-align: left;'> 4 </th> <th style='text-align: left;'> 5 </th>  </tr> </thead> <tbody>\n  <tr> <td> B </td> <td> Iva </td> <td> Kou </td> <td> Vvp </td> <td> Des </td> </tr>\n   </tbody> </table>"

---

    Code
      rows()
    Output
      # A tibble: 5 x 25
        referentiecode referentie_omsla~ sortering referentienummer omschrijving_verk~
        <chr>          <chr>             <chr>     <chr>            <chr>             
      1 B              <NA>              <NA>      <NA>             BALANS            
      2 BIva           <NA>              A         01               Immateriële vaste~
      3 BIvaKou        <NA>              A.A       0101000          Kosten van oprich~
      4 BIvaKouVvp     <NA>              A.A.A     0101010          Verkrijgings- of ~
      5 BIvaKouVvpDes  <NA>              A.A.A040  0101010.04       Desinvesteringen  
      # ... with 20 more variables: omschrijving <chr>, d_c <chr>, nivo <dbl>,
      #   zzp_belastingdienst_pilot_zol_awa <lgl>, basis <lgl>, uitgebr <lgl>,
      #   ez_vof_12 <lgl>, zzp <lgl>, wo_co_14 <lgl>, bb <lgl>, agro <lgl>,
      #   wkr <lgl>, ez_vof_18 <lgl>, bv <lgl>, wo_co_20 <lgl>, bank <lgl>,
      #   ozw_coop_sticht_fwo <lgl>, afrek_syst <lgl>, nivo5 <lgl>, uitbr5 <lgl>

---

    Code
      output$reference
    Output
      [1] "<table  class = 'table shiny-table table- spacing-s' style = 'width:auto;'>\n<thead> <tr> <th style='text-align: left;'> 1 </th> <th style='text-align: left;'> 2 </th> <th style='text-align: left;'> 3 </th> <th style='text-align: left;'> 4 </th>  </tr> </thead> <tbody>\n  <tr> <td> B </td> <td> Iva </td> <td> Kou </td> <td> Vvp </td> </tr>\n   </tbody> </table>"

---

    Code
      rows()
    Output
      # A tibble: 5 x 25
        referentiecode referentie_omsla~ sortering referentienummer omschrijving_verk~
        <chr>          <chr>             <chr>     <chr>            <chr>             
      1 B              <NA>              <NA>      <NA>             BALANS            
      2 BIva           <NA>              A         01               Immateriële vaste~
      3 BIvaKou        <NA>              A.A       0101000          Kosten van oprich~
      4 BIvaKouVvp     <NA>              A.A.A     0101010          Verkrijgings- of ~
      5 BIvaKouVvp     <NA>              A.A.A     0101010          Verkrijgings- of ~
      # ... with 20 more variables: omschrijving <chr>, d_c <chr>, nivo <dbl>,
      #   zzp_belastingdienst_pilot_zol_awa <lgl>, basis <lgl>, uitgebr <lgl>,
      #   ez_vof_12 <lgl>, zzp <lgl>, wo_co_14 <lgl>, bb <lgl>, agro <lgl>,
      #   wkr <lgl>, ez_vof_18 <lgl>, bv <lgl>, wo_co_20 <lgl>, bank <lgl>,
      #   ozw_coop_sticht_fwo <lgl>, afrek_syst <lgl>, nivo5 <lgl>, uitbr5 <lgl>

