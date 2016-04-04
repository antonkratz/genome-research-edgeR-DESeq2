get the input data from the paper:

```
wget http://genome.cshlp.org/content/suppl/2014/06/05/gr.164095.113.DC1/Supplemental_Table.S3.xlsx
```

open the table with gnumeric 1.12.24.

export the first sheet as ASCII:

```
"Data -> Export Data -> Export as CSV file..."
```

now I have the data in a file `Supplemental_Table.S3.csv`

dump the unnecessary columns, replace the comma with TAB:

```
mv Supplemental_Table.S3.csv data/S3.csv
sed 's/,/\t/g' S3.csv | cut -f 1-5,10-27 > data/expr_table.bound_vs_unbound.csv
sed 's/,/\t/g' S3.csv | cut -f 1,2,4,10-23,26,27 > data/expr_table.bmemb_vs_bcyto.csv
```

delete the id field with vi. the file should not start with a tab (i.e. delete the tab after "vi").

I can now use `expr_table.bound_vs_unbound.csv` as DESeq2 input!

Manually prepare a `expr_table.desc.bound_vs_unbound.csv` file.

Execute this in RStudio, or just run

```
R CMD BATCH edgeR.bound_vs_unbound.R
```

...okay now I have the results. Add columns with gene symbol and representative cluster. The idea is to sort the original sheet, sort the results file, and add the two columns.


```
tail -n+2 data/edgeR.bound_vs_unbound.txt | sort -k 1,1 > data/srtd.payload
tail -n+2 data/S3.csv | sort -k 1,1 | cut -d "," -f 1,64 | sed 's/,/\t/g' > data/srtd.S3.csv
paste data/srtd.payload data/srtd.S3.csv | cut -f 1-6,8 > foobar 
cat data/header_wh_symbol foobar >> out/edgeR.bound_vs_unbound.tsv

tail -n+2 data/edgeR.bmemb_vs_bcyto.txt | sort -k 1,1 > data/srtd.payload
tail -n+2 data/S3.csv | sort -k 1,1 | cut -d "," -f 1,64 | sed 's/,/\t/g' > data/srtd.S3.csv
paste data/srtd.payload data/srtd.S3.csv | cut -f 1-6,8 > foobar 
cat data/header_wh_symbol foobar >> out/edgeR.bmemb_vs_bcyt.tsv
```

`DESeq2IVA_bound_vs_unbound.tsv` can now be loaded into DESeq2IVA, done.


