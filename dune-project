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
  (synopsis "Bioinformatics pipeline library")
  (description "Biotope provides a collection of building blocks to
                construct analysis pipelines in bioinformatics. It
                specializes in NGS analysis, genomics and
                phylogeny. The library comes in two flavours: either a
                simple, integrated API named biotope-light, or a more
                advanced relying on bistro workflows that can be more
                easily extended.")
  (depends biotk bistro))
