# parent and weight generation work

    Code
      parent_seeker(get_standard_business_reporting("Nederland"))
    Output
      # A tibble: 4,571 x 26
         parent  child referentie_omsl~ sortering referentienummer omschrijving_verko~
         <chr>   <chr> <chr>            <chr>     <chr>            <chr>              
       1 ""      B     <NA>             <NA>      <NA>             BALANS             
       2 "B"     BIva  <NA>             A         01               Immateriële vaste ~
       3 "BIva"  BIva~ <NA>             A.A       0101000          Kosten van opricht~
       4 "BIvaK~ BIva~ <NA>             A.A.A     0101010          Verkrijgings- of v~
       5 "BIvaK~ BIva~ <NA>             A.A.A010  0101010.01       Beginbalans (overn~
       6 "BIvaK~ BIva~ <NA>             A.A.A020  0101010.02       Investeringen      
       7 "BIvaK~ BIva~ <NA>             A.A.A030  0101010.03       Bij overname verkr~
       8 "BIvaK~ BIva~ <NA>             A.A.A040  0101010.04       Desinvesteringen   
       9 "BIvaK~ BIva~ <NA>             A.A.A050  0101010.05       Afstotingen        
      10 "BIvaK~ BIva~ <NA>             A.A.A080  0101010.06       Omrekeningsverschi~
      # ... with 4,561 more rows, and 20 more variables: omschrijving <chr>,
      #   d_c <chr>, nivo <dbl>, zzp_belastingdienst_pilot_zol_awa <lgl>,
      #   basis <lgl>, uitgebr <lgl>, ez_vof_12 <lgl>, zzp <lgl>, wo_co_14 <lgl>,
      #   bb <lgl>, agro <lgl>, wkr <lgl>, ez_vof_18 <lgl>, bv <lgl>, wo_co_20 <lgl>,
      #   bank <lgl>, ozw_coop_sticht_fwo <lgl>, afrek_syst <lgl>, nivo5 <lgl>,
      #   uitbr5 <lgl>

---

    Code
      add_weight(tb)
    Output
      # A tibble: 4,571 x 28
         parent  child referentie_omsl~ sortering referentienummer omschrijving_verko~
         <chr>   <chr> <chr>            <chr>     <chr>            <chr>              
       1 ""      B     <NA>             <NA>      <NA>             BALANS             
       2 "B"     BIva  <NA>             A         01               Immateriële vaste ~
       3 "BIva"  BIva~ <NA>             A.A       0101000          Kosten van opricht~
       4 "BIvaK~ BIva~ <NA>             A.A.A     0101010          Verkrijgings- of v~
       5 "BIvaK~ BIva~ <NA>             A.A.A010  0101010.01       Beginbalans (overn~
       6 "BIvaK~ BIva~ <NA>             A.A.A020  0101010.02       Investeringen      
       7 "BIvaK~ BIva~ <NA>             A.A.A030  0101010.03       Bij overname verkr~
       8 "BIvaK~ BIva~ <NA>             A.A.A040  0101010.04       Desinvesteringen   
       9 "BIvaK~ BIva~ <NA>             A.A.A050  0101010.05       Afstotingen        
      10 "BIvaK~ BIva~ <NA>             A.A.A080  0101010.06       Omrekeningsverschi~
      # ... with 4,561 more rows, and 22 more variables: omschrijving <chr>,
      #   d_c <chr>, nivo <dbl>, zzp_belastingdienst_pilot_zol_awa <lgl>,
      #   basis <lgl>, uitgebr <lgl>, ez_vof_12 <lgl>, zzp <lgl>, wo_co_14 <lgl>,
      #   bb <lgl>, agro <lgl>, wkr <lgl>, ez_vof_18 <lgl>, bv <lgl>, wo_co_20 <lgl>,
      #   bank <lgl>, ozw_coop_sticht_fwo <lgl>, afrek_syst <lgl>, nivo5 <lgl>,
      #   uitbr5 <lgl>, level <chr>, weight <dbl>

