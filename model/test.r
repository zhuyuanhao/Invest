filename="/Users/qiuxe/data/stock/600978.ss.csv";
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

latest<- function(x, days){
	x<- scale(x);
	n<- length(x);
	return(x[(n-days+1):n]);
}
myfft<- function(x, k=1){
	#the function return the energy percentage of the k low  frequencies 
	if(k>=length(x))return(1);
	z<- fft(x);
	z_mod<- Mod(z)^2;
	percent<- sum(z_mod[1:k])/sum(z_mod);
	return(percent);
}
myacf<- function(x, win_size, max_lag=30){
	max_lag=win_size;
	n<- length(x);
	par(mfrow=c(2,3));
	plot(x[(n-win_size+1):n],type="o");
	#dev.new();
	acf(x[(n-win_size+1):n],lag.max=max_lag);
}
plot_latest<- function(x){
	
}
time_delay<- function(x, t){
	n<- length(x);
	x_neg<- x[1];
	y<- numeric(n);
	y[1:t]<- x_neg;
	y[(t+1):n]<- x[1:(n-t)];
	return(y);	
}
auto_cor<- function(x, max_lag){
	#almost the same as acf
	cor_val<- 1:max_lag;
	cor_val<- sapply(cor_val, function(t){
				return(cor(x,time_delay(x,t)));});
	return(cor_val);	
}
fit_periodicity<- function(x, T){
	n<- length(x);
	x<- scale(x[(n-2*T+1):n]);
	x1<- x[1:T];
	x2<- x[-(1:T)];
	return(sum(x1*x2)/T);
}
l2_norm<- function(x){
	return(sqrt(sum(x^2)));
}
periodicity<- function(x, min_T=10, max_T=30){
	n<- length(x);
	if(n<2*max_T) return(c(-1,-1));
	sub<- min_T:max_T;
	cor_val<- sapply(sub, function(t){
				return(fit_periodicity(x,t));});
	max_ind<- which.max(cor_val);
	max_val<- cor_val[max_ind];
	best_T<- sub[max_ind];
	curr_pos<- (x[n]-min(x[(n-best_T+1):n]))/(max(x[(n-best_T+1):n])-min(x[(n-best_T+1):n]));
	return(c(best_T,max_val, curr_pos));
}

test<- function(code){
	#code=600048;
	filename=paste("/Users/qiuxe/data/stock/",code,".ss.csv", sep="");	
	x<- read_data(filename); 
	dev.new(); 
	plot(latest(x,102), type="o");
	print(myfft(latest(x,100),10));
	myacf(x,100);

}

filelist<- read.table("filelist.xls");
filelist<- as.vector(filelist[,1]);
data_dir<- "/Users/qiuxe/data/stock/";
results<- numeric(0);
for(filename in filelist){
	file_path<- paste(data_dir,filename,sep="");
	print(file_path);
	x<- read_data(file_path);
	rec<- c(periodicity(x),filename);
	print(rec);
	results<- rbind(results,rec);
}
results<- results[sort(as.numeric(results[,2]), decreasing=T, index.return=T)$ix,];
write.table(results, "results.xls", sep="\t", row.names=F, col.names=F, quote=F);
print("done");

source("functions.r");
xx<- batch_read_data("/Users/qiuxe/data/stock/", 100);
x<- xx[,-(1:40)];
codes<- rownames(x);
x<- t(scale(t(x)));
n<- nrow(x);
p<- col(x);
k<- 5;
model<- cor_kmeans(x,k, iter.max=30);
plot_centers(model$centers);


cor_val<- sapply(1:n, function(i){
	cor_with_centers<- sapply(1:k, function(j){
		return(cor(x[i,], as.numeric(model$centers[j,]))); });
	return(c(codes[i],model$cluster[i],  which.max(cor_with_centers), max(cor_with_centers), cor_with_centers));
});
cor_val<- t(cor_val); colnames(cor_val)<- c("codes", "cluster", "nearest","max_cor", 1:k);
sub<- which(as.numeric(cor_val[,"max_cor"])>0.95);

print(cor_val[sample(n,5),], quote=F);


