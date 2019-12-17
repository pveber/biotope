(lang dune 1.10)
(generate_opam_files true)

(name biotope)
(source (github pveber/biotope))
(homepage "https://github.com/pveber/biotope/")
(bug_reports "https://github.com/pveber/biotope/issues")
(license CeCILL-B)
(authors "Philippe Veber")
(maintainers "philippe.veber@gmail.com")

(package
  (name biotope)
  (tags (bioinformatics))
  (depends
    bistro))
