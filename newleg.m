%Leg Automation
%Last Update: 11/13/15

function [peaktype,returnpeakstart,returnpeakend,returnpeakmean] = newleg(n)
%FOR TESTING ONLY:
%n=200; %195-305,495-605,795-905,1095-1205,1395-1505,1695-1805
%%%%%%%%%%%%
filename = '/Users/Ethan/Documents/code/yateslab/2.3 Cell 1 7a.txt';
df = importdata(filename, '\t', 1);
baseline = df.data(51:200,2);
base_mean = mean(baseline);
thresh_up = 1.2*base_mean;
thresh_down = 0.8*base_mean;
pos_epeaks1 = [];
pos_ipeaks1 = [];
maxcount=n+300;
n=n-2;
starting_n = n;
while n+5 <= maxcount
  avg = df.data(n:n+5,2);
  [p,~,~] = ranksum(avg,baseline);
  if p <= 0.05
      if mean(avg) >= thresh_up
          pos_epeaks1 = [pos_epeaks1 n];
          x = [0 cumsum(diff(pos_epeaks1)~=1)];
          pos_epeaks1(x==mode(x));
      elseif mean(avg) <= thresh_down
        pos_ipeaks1 = [pos_ipeaks1 n];
        x = [0 cumsum(diff(pos_ipeaks1)~=1)];
        pos_ipeaks1(x==mode(x));
      else
          disp(strcat(num2str(n),' Sig and False'))
      end 
  end
  n = n+1;
end
excitatory_max = max(pos_epeaks1);
excitatory_min = min(pos_epeaks1);
inhibitory_max = max(pos_ipeaks1);
inhibitory_min = min(pos_ipeaks1);
excitatory_mean = mean(df.data(excitatory_min:excitatory_max,2));
inhibitory_mean = mean(df.data(inhibitory_min:inhibitory_max,2));
excitatory_mag = excitatory_mean/base_mean -1 ;
inhibitory_mag = 1 - inhibitory_mean/base_mean;
if excitatory_mag > inhibitory_mag
    peaktype='E';
else
    peaktype='I';
end
if  peaktype == 'E';
    peakmean= excitatory_mean;
    peak_start = excitatory_min;
    peak_end = excitatory_max+5;
else
    peakmean = inhibitory_mean;
    peak_start = inhibitory_min;
    peak_end = inhibitory_max+5;
end
returnpeakstart = peak_start;
returnpeakend = peak_end;
returnpeakmean = peakmean;
end