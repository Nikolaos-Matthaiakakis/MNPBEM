# MNPBEM
MNPBEM (https://physik.uni-graz.at/de/mnpbem/) is a toolbox for the simulation of metallic nanoparticles (MNP), using a boundary element method (BEM) approach developed by F. J. Garcia de Abajo and A. Howie, Phys. Rev. B 65, 115418 (2002). The main purpose of the toolbox is to solve Maxwell's equations for a dielectric environment where bodies with homogeneous and isotropic dielectric functions are separated by abrupt interfaces. Although the approach is in principle suited for arbitrary body sizes and photon energies, it is tested (and probably works best) for metallic nanoparticles with sizes ranging from a few to a few hundreds of nanometers, and for frequencies in the optical and near-infrared regime.

From our experience with the toolbox it appears that there exist no "standard" applications, but each problem requires a slightly different implementation. For this reason we have decided to provide a set of general Matlab® classes that can be easily combined to simulate the problem of interest. The toolbox comes along with detailed help pages and a number of examples that can be used as templates for other simulations.

**Reference and Download**

When publishing results obtained with the MNPBEM toolbox, we ask you to cite one of the following papers:

    U. Hohenester and A. Trügler, Comp. Phys. Commun. 183, 370 (2012).
    U. Hohenester, Comp. Phys. Commun. 185, 1177 (2014).
    J. Waxenegger, A. Trügler, and U. Hohenester, Comp. Phys. Commun. 193, 138 (2015).

In comparison to the toolbox published in these papers, the current version includes a number of new features, as detailed in the help pages of the toolbox. Also the calling sequence for some of the classes and functions has changed.


**Copyright.** The MNPBEM toolbox is distributed under the terms of the GNU General Public License. See the file COPYING in the main directory for license details.
**Download.** For the download you must provide your name and a valid e-mail address. The current version MNPBEM17 of the toolbox can be downloaded here: mnpbem17.zip, the previous version MNPBEM14 here: mnpbem14.zip.
**Installation.**  Unzip the downloaded file and follow the instructions given in the file Readme.txt in the main directory of the toolbox.
**Developers.** Ulrich Hohenester, Andreas Trügler (University of Graz)



