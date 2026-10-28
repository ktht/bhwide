      PROGRAM MAIN
*     ************
!---------------------------------------------------------------!
! Simple demo of the program BHWIDE for wide-angle Bhabha       !
!---------------------------------------------------------------!
      IMPLICIT REAL*8 (A-H,O-Z) 
! Histograms in blank common   
      COMMON / cglib / b(50000)
! Initialization of histogramming package --
! Here we use double precision HBOOK-like histogramming/plotting
! package GLIBK written by S. Jadach, (1990),  unpublished.
      CALL GLIMIT(50000) 
      CALL GOUTPU(16)
! Simple demonstration program
      CALL BHWdem
      END

      SUBROUTINE BHWdem
*     *****************
!---------------------------------------------------------------!
! Simplistic demo of BHWIDE:                                    !
! Generating some low statistic sample, producing a few         !
! histograms and printing output.                               !
!---------------------------------------------------------------!
      IMPLICIT REAL*8 (A-H,O-Z) 
! Input/output files
      COMMON / INOUT  / NINP,NOUT
      DIMENSION  xpar(100),npar(100)
      SAVE 
!
      ninp = 5
! General Output for everybody including glibk
      nout = 16
      OPEN(nout,FILE='./demo.output')
      REWIND(nout)
      CALL goutpu(nout)
      WRITE(nout,*) '   '
      WRITE(nout,*) '=============================================='
      WRITE(nout,*) '==========*********************==============='
      WRITE(nout,*) '==========***    BHWdem     ***==============='
      WRITE(nout,*) '==========*********************==============='
      WRITE(nout,*) '=============================================='
      WRITE(nout,*) '   '
!----------------------------------------------------------------------
! Input parameters for  BHWIDE
      CMSEne =  91.2    ! CMS Energy = 2*Ebeam [GeV]
      ThMinp =  25.0    ! Detector range ThetaMin [deg] for positrons
      ThMaxp = 155.0    ! Detector range ThetaMax [deg] for positrons
      ThMine =  25.0    ! Detector range ThetaMin [deg] for electrons
      ThMaxe = 155.0    ! Detector range ThetaMax [deg] for electrons
      EnMinp =   1.0    ! Energy minimum [GeV] for detected positrons
      EnMine =   1.0    ! Energy minimum [GeV] for detected electrons
      Acolli =  10.0    ! Maximum acollinearity [deg] of final e+e-
      epsCMS =  1d-5    ! Infrared cut on photon energy 
      WTMAX  =   3.0    ! Maximum Weight for rejection
      AMAZ   =  91.188  ! Z mass
      GAMMZ  =  2.4955  ! Z width (may be recalculated by EW library)
      SINW2  =  0.23122 ! sin^2(theta_W) (may be recalculated by EW library)   
      AMTOP  = 172.56   ! top quark mass
      AMHIG  = 125.20   ! Higgs mass      
! Try both options for KeyWgt, result should be the same
      KeyWgt =   0   ! unweighted (WT=1) events, for detector simulation
!#      KeyWgt =   1   ! weighted events
      KeyRnd =   1   ! RANMAR random numbers
      KeyCha =   0   ! Channel choice: all/s-only/t-only: =0/1/2
      KeyZof =   0   ! Z-contribution ON/OFF: =0/1
      KeyOpt = 1000*KeyZof +100*KeyCha +10*KeyWgt + KeyRnd
!#      KeyEWC =   0   ! QED corrections only 
      KeyEWC =   1   ! Total O(alpha) ElectroWeak corr. included
!#      KeyLib = 1   ! ElectroWeak corrections from BABAMC (obsolete!)
      KeyLib =   2   ! ElectroWeak corrections from ALIBABA
      KeyMod =   1   ! Hard bremsstr. matrix element from MODEL1
!#      KeyMod =   2   ! Hard bremsstr. matrix alement from MODEL2
      KeyPia =   4   ! Vacuum polarization option (0/1/2/3/4)
      KeyRad = 1000*KeyEWC + 100*KeyLib + 10*KeyMod + KeyPia
! Filling BHWIDE parameter arrays
      npar( 1) = KeyOpt
      npar( 2) = KeyRad
!
      xpar( 1) = CMSEne
      xpar( 2) = ThMinp
      xpar( 3) = ThMaxp
      xpar( 4) = ThMine
      xpar( 5) = ThMaxe
      xpar( 6) = EnMinp
      xpar( 7) = EnMine
      xpar( 8) = Acolli
      xpar( 9) = epsCMS
      xpar(10) = WTMAX
      xpar(11) = AMAZ
      xpar(12) = GAMMZ
      xpar(13) = SINW2     
      xpar(14) = AMTOP
      xpar(15) = AMHIG
!---------------------------------------------------------------------- 
!--- Initialization of BHWIDE
      CALL BHWIDE(-1,xpar,npar)
! Book histograms
      CALL Example(-1,xpar,npar)
!---------------------------------------------------------------------- 
! Number of events to be generated
      NevTot = 100000
!
      WRITE(6,*) '   '
      WRITE(6,*) '--------------  BHWdem ----------------------'
      WRITE(6,'(F10.2,A)') NevTot/1.E3,' Kilo-events requested'
      WRITE(6,*)  ' =======> Generation starts...'
      WRITE(6,*) '   '
!=============================
! Main event generation loop 
!=============================
      DO Ievent = 1,NevTot
!--- Generation of a single event
         CALL BHWIDE( 0,xpar,npar)
! Fill histograms
         CALL Example( 0,xpar,npar)
! Print four-momenta of first events
         IF (Ievent.LE.5) CALL dumps(nout)  
         IF (Ievent.LE.5) CALL dumps( 6)  
         IF (MOD(Ievent,10000) .EQ. 0) THEN
            WRITE(nout,1)' Ievent = ',Ievent,'[',Ievent*100/NevTot,'%]'
            WRITE(6   ,1)' Ievent = ',Ievent,'[',Ievent*100/NevTot,'%]'
         ENDIF
      ENDDO
 1    FORMAT(A,I7,A4,I3,A2)
!----------------------------------------------------------------------
      WRITE(6,*)  ' =======> Generation finished!'
      WRITE(6,*) '   '
!---------------------------------------------------------------------- 
!--- Finalization stage
      CALL BHWIDE( 2,xpar,npar)
! Save/Print histograms
      CALL Example( 1,xpar,npar)
!---------------------------------------------------------------------- 
! Print x-section
      Xsec = xpar(10)
      Erel = xpar(11)
      WRITE(nout,*)'|||||||||||||||||||||||||||||||||||||||||||||||||||'
      WRITE(nout,'(a,f15.8,a)')' Xsection_tot = ',Xsec    ,' [pb]'
     $                        ,' error        = ',Xsec*Erel,' [pb]'
      WRITE(nout,*)'|||||||||||||||||||||||||||||||||||||||||||||||||||'
      CLOSE(nout)
      END

      SUBROUTINE Example(mode,xpar,npar)
*     **********************************
!---------------------------------------------------------------!
! A simple example of a few histograms                          !
!---------------------------------------------------------------!
      IMPLICIT REAL*8 (A-H,O-Z) 
      PARAMETER( pi = 3.1415926535897932d0 )
! Input/output files
      COMMON / INOUT  / NINP,NOUT
      COMMON / MOMSET / p1(4),q1(4),p2(4),q2(4),phot(100,4),nphot
      COMMON / WGTALL / wtmod,wtcrud,wttrig,wtset(300)
      DIMENSION  xpar(*),npar(*)
      SAVE 
!
      IF (mode.EQ.-1) THEN
*     ====================
         KeyOpt = npar(1)
         KeyWgt = MOD(KeyOpt,100)/10   
         CMSEne = xpar(1)
         Ebeam = CMSEne/2
         s = CMSEne**2
! Deg --> rad    
         degrad = pi/180
         Nbin1 = 50
         CALL GBOOK1(1000,'e+: cos(Theta) distr.  $',Nbin1,-1d0,1d0)
         CALL GBOOK1(1100,'e-: cos(Theta) distr.  $',Nbin1,-1d0,1d0)
         Nbin2 = 60
         x1 =-6.0
         x2 = 0.0
         CALL GBOOK1(1200,'Energy distr: x=log10(1-s1/s) $',Nbin2,x1,x2)
         Ngmax = 20
         CALL GBOOK1(1300,'Photon multiplicity $',Ngmax,0d0,Ngmax*1d0)
         Nbin3 = 50
         IF (KeyWgt .NE .0) 
     &        CALL GBOOK1(1400,'Weight distribution $',Nbin3,-1d0,4d0)
         Nbin4 = 60
         thg1 = 0d0
         thg2 = 180d0
         CALL GBOOK1(1500,'Hardest phot.: theta (deg)$',Nbin4,thg1,thg2)
      ELSEIF (mode.EQ.0) THEN
*     =======================
! Calculate angles for events with non-zero weight
         tgetg = -1d0
         csthp = -2d0
         csthq = -2d0
         xnpho = -1d0
         vl = -1000d0
         IF(KeyWgt.EQ.0 .OR. wtcrud*wttrig.NE.0d0) THEN
            csthp = p2(3)/DSQRT(p2(1)**2+p2(2)**2+p2(3)**2)
            csthq = q2(3)/DSQRT(q2(1)**2+q2(2)**2+q2(3)**2)
! Energy lost distribution
            s1 = ( p2(4) + q2(4) )**2 - ( p2(3) + q2(3) )**2 
     &         - ( p2(2) + q2(2) )**2 - ( p2(1) + q2(1) )**2 
            v  = 1 - s1/s
            IF(v.GT.1d-10) vl = log10(v)
! Hardest photon angular distribution
            IF (nphot.GT.0) THEN
               thetg = DACOS( phot(1,3)/phot(1,4) ) /degrad
               CALL gf1(1500,thetg,wtmod)
            ENDIF
         ELSE
            CALL gf1(1500,thetg,wtmod)
         ENDIF
! Fill histograms
! Theta distribution
         CALL gf1(1000,csthp,wtmod)
         CALL gf1(1100,csthq,wtmod)
! Energy distribution
         CALL gf1(1200,vl,wtmod)
! Photon multiplicity distribution
         xnpho = nphot*1.01
         CALL gf1(1300,xnpho,wtmod)
! Weight distribution
         IF(KeyWgt .NE. 0) CALL gf1(1400,wtmod,1d0)
      ELSE 
*     ====
! Save/Print histograms
         CALL gprint(1000)
         CALL gprint(1100)
         CALL gprint(1200)
         CALL gprint(1300)
         IF(KeyWgt .NE. 0) CALL gprint(1400)
         CALL gprint(1500)
!----------------------------------------------------------------------
!----------------------------------------------------------------------
!----------------------------------------------------------------------
! The part below is optional i.e. it can be commented out.
! Up to four interesting plots will be  produced in LaTeX format
!----------------------------------------------------------------------
!----Initialize GPLOT               
         CALL gplint(0)                 
         noufig=11
         OPEN(noufig,file='demo.tex')
         CALL gplcap(-noufig)
! Re-Normalize properly histos in nanobarns
         Nevtot = npar(20)
         Xcru = xpar(20)
         xrange = 2d0         
         FacNor  = Nbin1/(Nevtot*ABS(xrange)) *Xcru
         CALL Gopera(1000,'+',1000,2000,FacNor,0d0)
         xrange = 2d0  
         FacNor  = Nbin1/(Nevtot*ABS(xrange)) *Xcru
         CALL Gopera(1100,'+',1100,2100,FacNor,0d0)
         xrange = x2 - x1          
         FacNor  = Nbin2/(Nevtot*ABS(xrange)) *Xcru
         CALL Gopera(1200,'+',1200,2200,FacNor,0d0)
         xrange = Ngmax
         Nbin   = Ngmax
         FacNor  = Nbin/(Nevtot*ABS(xrange)) *Xcru
         CALL Gopera(1300,'+',1300,2300,FacNor,0d0)
         FacNor  = 1/(Nevtot*1d0)
         CALL Gopera(1400,'+',1400,2400,FacNor,0d0)
         xrange = thg2 - thg1          
         FacNor  = Nbin4/(Nevtot*ABS(xrange)) *Xcru
         CALL Gopera(1500,'+',1500,2500,FacNor,0d0)
! Plot histos
         CALL GPLTIT('e+: d(sigma)/d(cos(theta)) [pb] $')        
         CALL gminim(2000, 0.0d0)
         CALL gmaxim(2000, 4.5d3)
         CALL gplset('DMOD',2d0)
         CALL gidopt(2000,'ERRO')
         CALL gplot( 2000,' ','B',0)
!
         CALL GPLTIT('e-: d(sigma)/d(cos(theta)) [pb] $')        
         CALL gminim(2100, 0.0d0)
         CALL gmaxim(2100, 4.5d3)
         CALL gplset('DMOD',2d0)
         CALL gidopt(2100,'ERRO')
         CALL gplot( 2100,' ','B',0)
!
         CALL GPLTIT('d(sigma)/d(x), x=log10(1-s1/s) [pb]$')        
         CALL gminim(2200, 0.0d0)
         CALL gmaxim(2200, 6d2)
         CALL gplset('DMOD',20d0)
         CALL gidopt(2200,'ERRO')
         CALL gplot( 2200,' ','B',0)
!
         CALL GPLTIT('d(sigma)/d(Ngamma), Photon multiplicity [pb]$')        
         CALL gminim(2300, 0.0d0)
         CALL gmaxim(2300, 6d2)
         CALL gplset('DMOD',2d0)
         CALL gidopt(2300,'ERRO')
         CALL gplot( 2300,' ','B',0)
!----------------------------------------------------------------------
! Only for weighted events !
         IF(KeyWgt .NE. 0) THEN
            CALL GPLTIT(' Main Weight; arbitrary normalization $')
            CALL gminim(2400, 0.0d0)
            CALL gmaxim(2400, 0.5d0)
            CALL gplset('DMOD',1d0)
            CALL gplot( 2400,' ','B',0)
         ENDIF
!
         CALL GPLTIT('Hardest photon: d(sigma)/d(theta) [pb/rad] $')        
         CALL gminim(2500, 0.0d0)
         CALL gmaxim(2500, 8d1)
         CALL gplset('DMOD',2d0)
         CALL gidopt(2500,'ERRO')
         CALL gplot( 2500,' ','B',0)
!
!---- Close TeX file and output
         CALL gplend
      ENDIF
      END
