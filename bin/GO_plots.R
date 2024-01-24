args = commandArgs(trailingOnly=TRUE)
sample_name=args[1]

library(ggthemes)
library(ggplot2)

dataCC=read.csv("GO_cellular.csv", header = F)
dataCC$V2=trimws(gsub("\\s+", " ", dataCC$V2))
write.table(dataCC, paste0(sample_name, "_GO_cellular.txt"), sep = "\t", row.names = FALSE, col.names = FALSE)
write.table(dataCC, paste0(sample_name, "_GO_cellular.csv"), sep = ",", row.names = FALSE, col.names = FALSE)

dataMF=read.csv("GO_molecular.csv", header = F)
dataMF$V2=trimws(gsub("\\s+", " ", dataMF$V2))
write.table(dataMF, paste0(sample_name, "_GO_molecular.txt"), sep = "\t", row.names = FALSE, col.names = FALSE)
write.table(dataMF, paste0(sample_name, "_GO_molecular.csv"), sep = ",", row.names = FALSE, col.names = FALSE)

dataBP=read.csv("GO_biological.csv", header = F)
dataBP$V2=trimws(gsub("\\s+", " ", dataBP$V2))
write.table(dataBP, paste0(sample_name, "_GO_biological.txt"), sep = "\t", row.names = FALSE, col.names = FALSE)
write.table(dataBP, paste0(sample_name, "_GO_biological.csv"), sep = ",", row.names = FALSE, col.names = FALSE)


#CC
nlim=round((head(dataCC$V1,n = 1)+150),digits = -2)
p1<-ggplot(data=dataCC, aes(x=reorder(V2,V1), y=V1))+
  geom_bar(stat="identity", fill="green", width=.5)+
  coord_flip()+labs(x="Classification",y="Number of Sequences")+
  geom_text(aes(label=V1), position=position_dodge(width=0.7), vjust=-0.0005, hjust=-.15)+
  theme(axis.text=element_text(size=10))+ylim(0,nlim)+theme(text = element_text(size = 15))+
  theme(axis.text.x=element_text(size=12,angle=0))+theme(axis.title=element_text(size=15,face="bold"))+
  ggtitle(paste(sample_name,"Cellular Componenet GOs",sep=" "))+
  theme(plot.title = element_text(family="sans", colour = "black", size = rel(1.1)*1, face = "bold"))

#ggsave(filename = paste(sample_name,"_Cellular_Component.svg",sep=""),width = 15 ,height = 7)
#ggsave(filename = paste(sample_name,"_Cellular_Component.pdf",sep=""),width = 15 ,height = 7)
pdf(paste(sample_name,"_Cellular_Component.pdf",sep=""),width = 15 ,height = 7)
print(p1)
dev.off()
svg(paste(sample_name,"_Cellular_Component.svg",sep=""),width = 15 ,height = 7)
print(p1)
dev.off()

#MF
nlim=round((head(dataMF$V1,n = 1)+150),digits = -2)
p2 <-ggplot(data=dataMF, aes(x=reorder(V2,V1), y=V1))+
  geom_bar(stat="identity", fill="blue", width=.5)+
  coord_flip()+labs(x="Classification",y="Number of Sequences")+
  geom_text(aes(label=V1), position=position_dodge(width=0.7), vjust=-0.0005, hjust=-.15)+
  theme(axis.text=element_text(size=10))+ylim(0,nlim)+theme(text = element_text(size = 15))+
  theme(axis.text.x=element_text(size=12,angle=0))+theme(axis.title=element_text(size=15,face="bold"))+
  ggtitle(paste(sample_name,"Molecular Function GOs",sep=" "))+
  theme(plot.title = element_text(family="sans", colour = "black", size = rel(1.1)*1, face = "bold"))

#ggsave(filename = paste(sample_name,"_Molecular_Function.svg",sep=""),width = 15 ,height = 7)
#ggsave(filename = paste(sample_name,"_Molecular_Function.pdf",sep=""),width = 15 ,height = 7)
pdf(paste(sample_name,"_Molecular_Function.pdf",sep=""),width = 15 ,height = 7)
print(p2)
dev.off()
svg(paste(sample_name,"_Molecular_Function.svg",sep=""),width = 15 ,height = 7)
print(p2)
dev.off()

#BP
nlim=round((head(dataBP$V1,n = 1)+150),digits = -2)
p3<-ggplot(data=dataBP, aes(x=reorder(V2,V1), y=V1))+
  geom_bar(stat="identity", fill="red", width=.5)+
  coord_flip()+labs(x="Classification",y="Number of Sequences")+
  geom_text(aes(label=V1), position=position_dodge(width=0.7), vjust=-0.0005, hjust=-.15)+
  theme(axis.text=element_text(size=10))+ylim(0,nlim)+theme(text = element_text(size = 15))+
  theme(axis.text.x=element_text(size=12,angle=0))+theme(axis.title=element_text(size=15,face="bold"))+
  ggtitle(paste(sample_name,"Biological Processes GOs",sep=" "))+
  theme(plot.title = element_text(family="sans", colour = "black", size = rel(1.1)*1, face = "bold"))

#ggsave(filename = paste(sample_name,"_Biological_Processes.svg",sep=""),width = 15 ,height = 7)
#ggsave(filename = paste(sample_name,"_Biological_Processes.pdf",sep=""),width = 15 ,height = 7)
pdf(paste(sample_name,"_Biological_Processes.pdf",sep=""),width = 15 ,height = 7)
print(p3)
dev.off()
svg(paste(sample_name,"_Biological_Processes.svg",sep=""),width = 15 ,height = 7)
print(p3)
dev.off()
