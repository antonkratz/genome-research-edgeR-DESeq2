This project describes how to generate the example data for DEIVA, https://github.com/Hypercubed/DEIVA.

Get the input data from Kratz, Anton, et al. "Digital expression profiling of the compartmentalized translatome of Purkinje neurons." Genome research 24.8 (2014): 1396-1410. http://genome.cshlp.org/content/24/8/1396

```
wget http://genome.cshlp.org/content/suppl/2014/06/05/gr.164095.113.DC1/Supplemental_Table.S3.xlsx
```

Export the first sheet as ASCII. To do this open the table with a spreadsheet application, here I use gnumeric 1.12.24.

```
"Data -> Export Data -> Export as CSV file..."
```

Now I have the data in a file `Supplemental_Table.S3.csv`

Simplify the file name, remove columns not relevant in this context, replace the comma with TAB:

```
mv Supplemental_Table.S3.csv S3.csv
sed 's/,/\t/g' S3.csv | cut -f 1-5,10-27 > data/expr_table.bound_vs_unbound.csv
sed 's/,/\t/g' S3.csv | cut -f 1,2,4,10-23,26,27 > data/expr_table.bmemb_vs_bcyto.csv
```

**Delete the id field with vi. the file should not start with a TAB (i.e. delete the TAB after "id").**

I can now use `expr_table.bound_vs_unbound.csv` and `expr_table.bmemb_vs_bcyto.csv` as DESeq2 input.

Manually prepare a `expr_table.desc.bound_vs_unbound.csv` and `expr_table.desc.bmemb_vs_bcyto.csv` file.

Execute this in RStudio, or just run:

```
R CMD BATCH Rscripts/edgeR.bound_vs_unbound.R Rdump/edgeR.bound_vs_unbound.Rout
R CMD BATCH Rscripts/edgeR.bmemb_vs_bcyto.R Rdump/edgeR.bmemb_vs_bcyto.Rout
```

Add columns with gene symbol and representative cluster. The idea is to sort the original sheet, sort the results file, and add the two columns.


```
tail -n+2 out/edgeR/edgeR.bound_vs_unbound.txt | sort -k 1,1 > srtd.payload
tail -n+2 S3.csv | sort -k 1,1 | cut -d "," -f 1,64 | sed 's/,/\t/g' > srtd.S3.csv
paste srtd.payload srtd.S3.csv | cut -f 1-6,8 > foobar 
cat data/header_wh_symbol foobar >> annotated/edgeR/edgeR.bound_vs_unbound.tsv

tail -n+2 out/edgeR/edgeR.bmemb_vs_bcyto.txt | sort -k 1,1 > srtd.payload
tail -n+2 S3.csv | sort -k 1,1 | cut -d "," -f 1,64 | sed 's/,/\t/g' > srtd.S3.csv
paste srtd.payload srtd.S3.csv | cut -f 1-6,8 > foobar 
cat data/header_wh_symbol foobar > annotated/edgeR/edgeR.bmemb_vs_bcyto.tsv

rm srtd.payload
rm srtd.S3.csv
rm foobar
```

`DESeq2IVA_bound_vs_unbound.tsv` can now be loaded into DESeq2IVA, done.

Now also do this to generate the DESeq2-based input files. This uses the same input files, so I keep this in the same project.
```
R CMD BATCH Rscripts/DESeq2.bound_vs_unbound.R Rdump/DESeq2.bmemb_vs_bcyto.Rout
R CMD BATCH Rscripts/DESeq2.bmemb_vs_bcyto.R Rdump/DESeq2.bmemb_vs_bcyto.Rout
```

**Final results files w/o symbol: txt files in out.**

**Final results files w/h symbol: csv files in annotated.**

```
tail -n+2 out/DESeq2/DESeq2.bound_vs_unbound.txt | sort -k 1,1 > srtd.payload
tail -n+2 S3.csv | sort -k 1,1 | cut -d "," -f 1,64 | sed 's/,/\t/g' > srtd.S3.csv
paste srtd.payload srtd.S3.csv | cut -f 1-7,9 > foobar 
cat data/d2.header_wh_symbol foobar >> annotated/DESeq2/DESeq2.bound_vs_unbound.tsv

tail -n+2 out/DESeq2/DESeq2.bmemb_vs_bcyto.txt | sort -k 1,1 > srtd.payload
tail -n+2 S3.csv | sort -k 1,1 | cut -d "," -f 1,64 | sed 's/,/\t/g' > srtd.S3.csv
paste srtd.payload srtd.S3.csv | cut -f 1-7,9 > foobar 
cat data/d2.header_wh_symbol foobar >> annotated/DESeq2/DESeq2.bmemb_vs_bcyto.tsv

rm srtd.payload
rm srtd.S3.csv
rm foobar
```