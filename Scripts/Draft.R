setwd("~/Library/CloudStorage/OneDrive-u-bordeaux.fr/Postdoc_Italy/Script/Regional_model")

getwd()

# Fix the buffer size
Buffer <- as.list(c(1000,2000,3000,seq(5000,35000,5000)))
Buffer <- as.list(c(1000,2000,3000,4000,5000,6000))

# and loop over the years 

# Need to do the species accumulation = new species observed each year based on
# All previously observed species. 

for (i in 1:length(dfcity)){
  df <- dfcity[[i]]
  Center <- dfcenter[[i]]
  SP_DF = st_as_sf(df,coords=c("decimalLongitude","decimalLatitude"),
                   crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 ")
  City_center <- st_sfc(st_point(Center), crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0 ")
  Sp.Curve <- parallel::mclapply(Buffer, function(x) {
    circle <- st_buffer(City_center, x) 
    SP_DF_col <- st_cast(SP_DF, "POINT")
    INTER_point <- st_intersects(circle, SP_DF_col)[[1]]
    SP_DF_col_intersect <- SP_DF_col[INTER_point,]
    
    Year <- sort(unique(SP_DF_col_intersect$year))
    Species_accum_year <- vector("list",length(Year))
    names(Species_accum_year) <- Year
    
    # Here need to compare the list of species with the previous year. 
    #Remove length 
    for (i in 1:length(Year)){
    SP_DF_col_intersect_YEAR <- subset(SP_DF_col_intersect,year == Year[i],
                                       select=c("species","kingdom","class"))
    Tot_sp <- length(unique(SP_DF_col_intersect_YEAR$species))
    Tot_A <- sapply(lspecies, function(s){
      Tot_A <- SP_DF_col_intersect_YEAR %>% 
        st_drop_geometry
      if (s%in%c("Animalia","Plantae")){
        Tot_A <- subset(Tot_A,kingdom == s,select="species")
      } else {
        Tot_A <- subset(Tot_A,class == s,select="species")
      }
      Tot_A %>% unique %>% nrow
    })
    Species_accum <- c("Tot_sp"=Tot_sp,Tot_A)
    Species_accum <- as.data.frame(cbind("occurrence"=as.numeric(Species_accum),
                                         "Taxa"=names(Species_accum)))
    Species_accum$Distance <- x
    Species_accum$Year <- Year[i]
    Species_accum_year[[i]] <- Species_accum
    }
    Species_accum <- as.data.frame(do.call(rbind,Species_accum_year))
    ;Species_accum}
    ,mc.cores = 3)
  Sp.Curve <- as.data.frame(do.call(rbind,Sp.Curve))
  Sp.Curve$city <- names(lSp.Curve)[i]
  lSp.Curve[[i]] <- Sp.Curve
}
dfSp.Curve <- do.call(rbind,lSp.Curve)
dfSp.Curve$occurrence <- as.numeric(dfSp.Curve$occurrence)



