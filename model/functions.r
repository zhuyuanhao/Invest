read_data<- function(filename){
        xx<- read.table(filename, sep=",", head=T);
        names(xx)<- c("Date","Open","High","Low","Close","Volume","Adj");
        rm_non_trading<- function(xx){
                sub<- which(xx[,"Volume"]>0);
                return(xx[sub,]);
        }
        reverse<- function(xx){
                sub<- 1:nrow(xx);
                sub<- rev(sub);
                return(xx[sub,]);
        }
        xx<- rm_non_trading(xx);
        xx<- reverse(xx);

        n<- nrow(xx);

        x<- xx[,"Close"];
        return(x);
}

batch_read_data<- function(data_dir, days){
	xx<- numeric(0);
	filelist<- list.files(data_dir);
	not_read_sub<- numeric(0);
	for(i in 1:length(filelist)){
		filename<- filelist[i];
        	file_path<- paste(data_dir,filename,sep="");
		#print(file_path);
		file_info<- file.info(file_path);
		if(file_info[,"size"]>0){
        		x<- read_data(file_path);
			n<- length(x);
			if(days<=n){
				x<- x[(n-days+1):n]; #the latest days
				xx<- rbind(xx,x);
			}else{
				not_read_sub<- c(not_read_sub,i);
				cat("not read file ",filename, "\n");
			}
		}else{
			not_read_sub<- c(not_read_sub,i);
                        cat("empty file ",filename, "\n");
		}
	}
	rownames(xx)<- filelist[-not_read_sub];
	return(xx);
}


#kmeans using correlation as similarity
cor_kmeans<- function(x, k, iter.max=10){
	n<- nrow(x);
	p<- ncol(x);
	if(k>n){
		print("error: illegal k");
		return(NA);
	}
	centers<- x[sample(1:n,size=k, replace=F),];
	k_assign<- numeric(n);
	total_cor<- 0;
	for(loop in 1:iter.max){
		total_cor<- 0;
		k_assign<- apply(x, MARGIN=1, FUN=function(xi){
			#find nearest cluster center
			cor_val<- apply(centers, MARGIN=1, FUN=function(ci){
				return(cor(xi,ci));});
			#print(cor_val);
			sub<- which.max(cor_val);
			total_cor<- total_cor+cor_val[sub];
			return(sub);
		});
		centers<- aggregate(x, by=list(grp=k_assign), FUN=mean);
		centers<- centers[,-1]; # group id not need. but will centers or by grp?
		for(i in 1:(k-1)){
                	for(j in (i+1):k){
                        	total_cor<- total_cor+cor(as.numeric(centers[i,]), as.numeric(centers[j,]));
                	}
	        }
		total_cor<- total_cor/(0.5*k*(k-1));

		cat("loop ",loop, ", total_cor ", total_cor, "\n");
	}	
	model<- list(cluster=k_assign, centers=centers, tot.withinss=total_cor);
	
}

plot_centers<- function(centers){
	k<- nrow(centers);
	plot(as.numeric(centers[1,]), type="o", col=1, pch=1, ylim=c(-2,2));
	for(i in 2:k){
		points(as.numeric(centers[i,]), type="o", col=i, pch=i);
	}
	for(i in 1:(k-1)){
		for(j in (i+1):k){
			cat(i,j,cor(as.numeric(model$centers[i,]), as.numeric(model$centers[j,])),"\n");
		}
	}
}


