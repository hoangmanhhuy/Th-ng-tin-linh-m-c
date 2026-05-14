import { 
  Home, 
  Smartphone, 
  QrCode, 
  History, 
  Settings,
  Search,
  ChevronDown,
  Phone,
  Verified,
  User as UserIcon,
  LogOut,
  Bell,
  MoreVertical,
  Calendar,
  Sparkles,
  MapPin,
  GraduationCap,
  Mail,
  Info as InfoIcon,
  BadgeCheck,
  Circle,
  ShieldCheck,
  School,
  Building,
  ChevronRight,
  ArrowLeft,
  Flashlight,
  Image as ImageIcon,
  X,
  Lock,
  Eye,
  EyeOff,
  Church,
  Nfc,
  ArrowRight,
  Fingerprint,
  Maximize,
  Clock,
  Check,
  ListFilter,
  CheckCircle2,
  Rss,
  Contact,
  Menu,
  UserCog,
  Undo2,
  Languages,
  HelpCircle,
  BookOpen,
  Quote,
  Music,
  Star,
  Share2,
  Download
} from 'lucide-react';
import { motion, AnimatePresence } from 'motion/react';
import { useState } from 'react';
import { QRCodeCanvas } from 'qrcode.react';

// --- Shared Components ---

const getLiturgicalData = (date: Date) => {
  const dayNames = ["Chúa Nhật", "Thứ Hai", "Thứ Ba", "Thứ Tư", "Thứ Năm", "Thứ Sáu", "Thứ Bảy"];
  const currentDayName = dayNames[date.getDay()];
  const formattedDateString = `${currentDayName}, ${date.getDate()} Tháng ${date.getMonth() + 1}`;

  // Target year is 2026 for this prototype context (as seen in user metadata)
  // Easter 2026 is April 5th.
  const year = date.getFullYear();
  const month = date.getMonth(); // 0-indexed
  const day = date.getDate();

  // Simplified Liturgical Logic for the current period (May 2026)
  if (year === 2026 && month === 4) { // May 2026
    let week = "VI";
    if (day <= 2) week = "IV";
    else if (day <= 9) week = "V";
    else if (day <= 16) week = "VI";
    else if (day <= 23) week = "VII";
    else week = "VIII";

    return {
      dateString: formattedDateString,
      season: `Tuần ${week} Phục Sinh`,
      feast: day === 13 ? "Đức Mẹ Fatima. Lễ Nhớ." : day === 14 ? "Thánh Matthias, Tông đồ. Lễ Kính." : "Ngày tuần trong Mùa Phục Sinh",
      readings: [
        { label: "Bài Đọc I", text: day === 13 ? "Cv 17, 15.22—18,1" : day === 14 ? "Cv 1,15-17.20-26" : "Cv Lời Chúa", icon: BookOpen, color: "bg-blue-50", iconColor: "text-blue-500" },
        { label: "Đáp Ca", text: day === 13 ? "Tv 148, 1-2.11-12.13.14" : day === 14 ? "Tv 112,1-2.3-4.5-6.7-8" : "Tv Lời Chúa", icon: Music, color: "bg-indigo-50", iconColor: "text-indigo-500" },
        { label: "Tin Mừng", text: day === 13 ? "Ga 16, 12-15" : day === 14 ? "Ga 15,9-17" : "Ga Lời Chúa", icon: Quote, color: "bg-red-50", iconColor: "text-red-500" }
      ]
    };
  }

  return {
    dateString: formattedDateString,
    season: "Mùa Thường Niên",
    feast: "Ngày trong tuần",
    readings: [
      { label: "Bài Đọc I", text: "Lời Chúa hằng ngày", icon: BookOpen, color: "bg-blue-50", iconColor: "text-blue-500" },
      { label: "Đáp Ca", text: "Thánh vịnh đáp ca", icon: Music, color: "bg-indigo-50", iconColor: "text-indigo-500" },
      { label: "Tin Mừng", text: "Tin Mừng theo ngày", icon: Quote, color: "bg-red-50", iconColor: "text-red-500" }
    ]
  };
};

const AppLogo = ({ className = "w-10 h-10", iconClassName = "w-6 h-6", isWhite = false }: { className?: string, iconClassName?: string, isWhite?: boolean }) => {
  return (
    <div className={`rounded-2xl flex items-center justify-center shadow-lg transition-all ${isWhite ? 'bg-white shadow-black/5' : 'bg-primary shadow-primary/20'} ${className}`}>
      <svg 
        viewBox="0 0 24 24" 
        fill="none" 
        className={iconClassName}
        stroke="currentColor" 
        strokeWidth="2.5" 
        strokeLinecap="round" 
        strokeLinejoin="round"
      >
        <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" className={isWhite ? 'text-primary' : 'text-white'} />
        <path d="M12 8v8" className={isWhite ? 'text-primary' : 'text-white/80'} />
        <path d="M9 11h6" className={isWhite ? 'text-primary' : 'text-white/80'} />
      </svg>
    </div>
  );
};

const BottomNav = ({ activeTab, onTabChange }: { activeTab: string, onTabChange: (tab: string) => void }) => {
  const tabs = [
    { id: 'home', label: 'Trang chủ', icon: Home, color: 'bg-primary' },
    { id: 'nfc', label: 'Quét thẻ', icon: Nfc, color: 'bg-orange-500' },
    { id: 'scan', label: 'Quét QR', icon: QrCode, color: 'bg-blue-600' },
    { id: 'history', label: 'Lịch sử', icon: History, color: 'bg-tertiary' },
    { id: 'settings', label: 'Cài đặt', icon: Settings, color: 'bg-primary' },
  ];

  return (
    <nav className="absolute bottom-0 left-0 w-full z-50 bg-white/95 backdrop-blur-md border-t border-gray-100 flex justify-around items-center px-2 pb-8 pt-3 h-24 rounded-t-[32px] shadow-[0_-8px_32px_rgba(0,0,0,0.06)]">
      {tabs.map((tab) => {
        const isActive = activeTab === tab.id;
        return (
          <button
            key={tab.id}
            onClick={() => onTabChange(tab.id)}
            className={`flex flex-col items-center justify-center transition-all duration-500 rounded-[20px] ${
              isActive 
                ? `${tab.color} text-white px-5 py-2 shadow-lg shadow-black/10 -translate-y-1` 
                : 'text-gray-400 px-3 py-1 hover:text-primary transition-colors'
            }`}
          >
            <tab.icon className={`${isActive ? 'w-5 h-5' : 'w-6 h-6 mb-1'}`} />
            <span className={`text-[10px] font-black uppercase tracking-wider ${isActive ? 'mt-0.5' : ''}`}>
              {tab.label}
            </span>
            {isActive && (
              <motion.div 
                layoutId="activePill"
                className="absolute inset-0 rounded-[20px] ring-4 ring-white/20"
                transition={{ type: "spring", bounce: 0.2, duration: 0.6 }}
              />
            )}
          </button>
        );
      })}
    </nav>
  );
};

const DailyWordSection = () => {
  // Mock data for the Gospel of the day
  // In a real app, this would come from an API or a calculated liturgical calendar
  const dailyData = {
    verse: "Ta là con đường, là sự thật và là sự sống. Không ai đến được với Cha mà không qua Thầy.",
    ref: "Ga 14, 6",
    isObligation: true,
    feastName: "Lễ Kính Thánh Tâm Chúa Giêsu",
    celebrationColor: "text-red-600 bg-red-50 border-red-100"
  };

  return (
    <div className="bg-[#FFF9F2] rounded-[32px] p-6 border border-orange-50 relative overflow-hidden group">
      {/* Decorative Background Elements */}
      <div className="absolute -top-10 -right-10 w-32 h-32 bg-orange-100/30 rounded-full blur-2xl group-hover:bg-orange-200/40 transition-colors" />
      <div className="absolute -bottom-10 -left-10 w-24 h-24 bg-primary/5 rounded-full blur-xl" />

      <div className="relative z-10 flex flex-col gap-4">
        <div className="flex justify-between items-start">
          <div className="flex items-center gap-2">
            <div className="w-8 h-8 rounded-xl bg-orange-100 flex items-center justify-center text-orange-600 shadow-sm">
              <BookOpen className="w-4 h-4" />
            </div>
            <p className="text-[10px] font-black text-orange-400 uppercase tracking-[0.2em] font-display">Lời Chúa hôm nay</p>
          </div>
          
          {dailyData.isObligation && (
            <div className={`px-3 py-1 rounded-full border text-[9px] font-black uppercase tracking-wider flex items-center gap-1.5 shadow-sm ${dailyData.celebrationColor}`}>
              <div className="w-1.5 h-1.5 bg-red-500 rounded-full animate-pulse" />
              Lễ kính buộc
            </div>
          )}
        </div>

        <div className="space-y-3">
          {dailyData.feastName && (
            <h4 className="text-xs font-black text-orange-900 leading-tight">
              {dailyData.feastName}
            </h4>
          )}
          
          <div className="relative pt-2">
            <Quote className="absolute -top-1 -left-2 w-8 h-8 text-orange-100 opacity-60" />
            <p className="text-[15px] font-display font-medium text-gray-800 leading-relaxed italic relative z-10 pl-2">
              "{dailyData.verse}"
            </p>
            <div className="flex justify-end mt-2">
              <span className="text-[10px] font-black text-primary px-3 py-1 bg-white rounded-full shadow-sm border border-orange-50">
                — {dailyData.ref}
              </span>
            </div>
          </div>
        </div>

        <button className="flex items-center gap-2 text-[11px] font-black text-orange-600 uppercase tracking-widest mt-1 group-hover:translate-x-1 transition-transform">
          Suy niệm thêm
          <ArrowRight className="w-3.5 h-3.5" />
        </button>
      </div>

      {/* Decorative Icon */}
      <div className="absolute right-4 bottom-4 opacity-[0.03] pointer-events-none">
        <BookOpen className="w-24 h-24 text-primary" />
      </div>
    </div>
  );
};

// --- Screens ---

const LaymanHomeScreen = ({ onPriestClick, onLoginClick }: { onPriestClick: () => void, onLoginClick: () => void }) => {
  return (
    <div className="flex flex-col gap-6 p-4 pb-32 overflow-x-hidden">
      <header className="flex justify-between items-center bg-white/90 backdrop-blur-md sticky top-0 z-40 -mx-4 px-4 py-3 border-b border-gray-50 shadow-sm">
        <div className="flex items-center gap-3">
           <AppLogo className="w-10 h-10" iconClassName="w-5.5 h-5.5" />
           <div>
              <h1 className="text-lg font-display font-extrabold text-primary leading-none uppercase tracking-tighter">Thông tin linh mục</h1>
           </div>
        </div>
        <button 
          onClick={onLoginClick}
          className="flex items-center gap-2 px-3 py-1.5 border border-outline-variant rounded-full text-primary font-bold text-xs"
        >
           <LogOut className="w-4 h-4 rotate-180" />
           Đăng nhập
        </button>
      </header>

      <section className="bg-white rounded-[32px] p-6 shadow-sm border border-gray-50">
         <h2 className="text-lg font-display font-extrabold mb-4">Tìm kiếm linh mục</h2>
         <div className="space-y-3">
            <div className="relative">
               <Search className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
               <input 
                type="text" 
                placeholder="Nhập tên linh mục" 
                className="w-full bg-surface-container-low rounded-2xl py-3.5 pl-11 pr-4 outline-none font-medium text-sm text-on-surface"
               />
            </div>
            <div className="relative">
               <MapPin className="absolute left-4 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
               <select className="w-full bg-surface-container-low rounded-2xl py-3.5 pl-11 pr-10 outline-none font-medium text-sm text-on-surface appearance-none">
                 <option>Chọn giáo phận</option>
               </select>
               <ChevronDown className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400 w-4 h-4" />
            </div>
         </div>
      </section>

      <div className="bg-[#FFF1F1] rounded-[32px] p-6 border border-red-50 flex items-center gap-4 relative overflow-hidden">
         <div className="flex-1">
            <p className="text-[10px] font-bold text-red-400 uppercase tracking-widest mb-1 font-display">Dành cho trường hợp khẩn cấp</p>
            <h3 className="text-xl font-display font-extrabold text-red-900 mb-1">Liên hệ xức dầu</h3>
            <p className="text-xs text-red-800/60 font-medium">Tìm linh mục gần nhất để cử hành bí tích</p>
         </div>
         <button className="w-14 h-14 bg-red-100 rounded-2xl flex items-center justify-center text-red-600 shadow-sm relative z-10">
            <Phone className="w-6 h-6 fill-red-600" />
         </button>
         <div className="absolute top-0 right-0 p-4 opacity-[0.03] pointer-events-none">
            <Phone className="w-24 h-24 text-red-900" />
         </div>
      </div>

      <DailyWordSection />

      <section>
         <div className="flex justify-between items-center mb-4 px-1">
            <h3 className="text-xl font-display font-extrabold">Linh mục tìm nhiều</h3>
            <button className="text-primary text-sm font-bold flex items-center gap-1">
               Xem tất cả <ChevronRight className="w-4 h-4" />
            </button>
         </div>
         
         <div className="space-y-4">
            <div 
              onClick={onPriestClick}
              className="bg-white p-4 rounded-[32px] shadow-sm border border-gray-50 flex gap-4 cursor-pointer"
            >
               <div className="relative">
                  <div className="w-24 h-32 rounded-2xl overflow-hidden bg-gray-100">
                    <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuAGmWxIVRZHVY7sZx9oNTNW9sV-enLy9YHyVPr-YRyTC4Vh6W_vmM2iDr1MD-CjemRbQACN9AAJ89iVpX3iHMBpP4GGL3a6piruosdhoQUUHTRPhlVWaKVNaHF8ANPbA9YUry1cGQS_jKFqI0UTjdy6_aYS5HyPXG40xuBs3O4il6AEKAGcxaeqzev1PRXYCDlSbDyswI3Z2mXxUwu9plX7-SPrJX-fD6vVa4QTxtxUNwB7i5sXy9uVOcmOvi_nqNb7-epUpvMR-K65" className="w-full h-full object-cover" />
                  </div>
                  <div className="absolute -bottom-2 left-1/2 -translate-x-1/2 bg-[#FFEEDD] text-[#884400] text-[10px] font-bold px-3 py-1 rounded-full whitespace-nowrap shadow-sm">
                    Sài Gòn
                  </div>
               </div>
               <div className="flex-1 py-1 flex flex-col justify-between">
                  <div>
                    <p className="text-xs font-bold text-primary font-display uppercase tracking-wider mb-0.5">LM. Giuse</p>
                    <h4 className="text-lg font-display font-black">Nguyễn Văn A</h4>
                  </div>
                  <div className="space-y-1.5 mt-2">
                    <div className="flex items-center gap-2 text-[13px] text-gray-500 font-medium">
                        <Church className="w-3.5 h-3.5 text-primary" />
                        <span>Giáo xứ Tân Định</span>
                    </div>
                    <div className="flex items-center gap-2 text-[13px] text-gray-500 font-medium">
                        <Verified className="w-3.5 h-3.5 text-primary" />
                        <span>Cha sở</span>
                    </div>
                  </div>
               </div>
            </div>

            <div className="bg-white p-4 rounded-[32px] shadow-sm border border-gray-50 flex gap-4">
               <div className="relative">
                  <div className="w-24 h-32 rounded-2xl overflow-hidden bg-gray-100">
                    <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuC6TC9vRUUgKI9T11hymO9XUCZRVVb69CUZXLKtVxoIHEuEfhl1s_2yYGFO-mMbl9c7RcVXdttqm3yrTWvxu1emm73FSoTyD7N0ue9KINtZ8ZJKV4QubADC1F3e0EB9k7qkZNyaUAMeYorTNXwrUCaleP8FeQ7Yw8pu-1SpPVTYYsA-eg69xRVA9yvpR8pIKAkvIM-faPi1gAula_lRAhHiyMSjCB3zlhyo1U7zTzWRanI9zZe0kMgK0Kcxs4WBdRcAVEcrZZZl_Gx-" className="w-full h-full object-cover" />
                  </div>
                  <div className="absolute -bottom-2 left-1/2 -translate-x-1/2 bg-[#E1EFFF] text-[#004AC6] text-[10px] font-bold px-3 py-1 rounded-full whitespace-nowrap shadow-sm">
                    Hà Nội
                  </div>
               </div>
               <div className="flex-1 py-1 flex flex-col justify-between">
                  <div>
                    <p className="text-xs font-bold text-primary font-display uppercase tracking-wider mb-0.5">LM. Phanxicô Xaviê</p>
                    <h4 className="text-lg font-display font-black">Trần Văn B</h4>
                  </div>
                  <div className="space-y-1.5 mt-2">
                    <div className="flex items-center gap-2 text-[13px] text-gray-500 font-medium">
                        <Church className="w-3.5 h-3.5 text-primary" />
                        <span>Đại chủng viện Thánh Giuse</span>
                    </div>
                    <div className="flex items-center gap-2 text-[13px] text-gray-500 font-medium">
                        <Verified className="w-3.5 h-3.5 text-primary" />
                        <span>Giáo sư</span>
                    </div>
                  </div>
               </div>
            </div>
         </div>
      </section>

      <section className="bg-surface-container rounded-[40px] p-8 space-y-8 mt-2">
         <div className="flex items-center gap-3">
            <InfoIcon className="w-6 h-6 text-primary" />
            <h3 className="text-xl font-display font-extrabold text-primary">Thông tin cần biết</h3>
         </div>
         <div className="flex gap-4">
            <div className="w-12 h-12 bg-white rounded-2xl flex items-center justify-center shadow-sm">
               <ShieldCheck className="w-6 h-6 text-primary fill-primary/10" />
            </div>
            <div className="flex-1">
               <h4 className="font-extrabold text-[15px] mb-1">Dữ liệu chính thức</h4>
               <p className="text-sm text-gray-500 font-medium leading-relaxed">Thông tin được xác thực bởi văn phòng các Giáo phận.</p>
            </div>
         </div>
         <div className="flex gap-4">
            <div className="w-12 h-12 bg-white rounded-2xl flex items-center justify-center shadow-sm">
               <Search className="w-6 h-6 text-primary" />
            </div>
            <div className="flex-1">
               <h4 className="font-extrabold text-[15px] mb-1">Hướng dẫn tìm kiếm</h4>
               <p className="text-sm text-gray-500 font-medium leading-relaxed">Sử dụng tên thánh hoặc tên thật để có kết quả chính xác nhất.</p>
            </div>
         </div>
      </section>
    </div>
  );
};

const LoginScreen = ({ onLogin, onBack }: { onLogin: () => void, onBack: () => void }) => {
  return (
    <div className="flex flex-col h-full bg-surface p-6 pt-8 overflow-hidden">
      {/* Icon & Title */}
      <div className="flex flex-col items-center mb-6 shrink-0">
        <AppLogo className="w-16 h-16 mb-4 !rounded-[24px]" iconClassName="w-9 h-9" />
        <h1 className="text-[28px] font-display font-black text-primary leading-tight">Thông Tin Linh Mục</h1>
        <p className="text-gray-400 font-bold text-xs mt-1">Đăng nhập Linh mục</p>
      </div>

      {/* Form Container */}
      <div className="bg-white rounded-[28px] p-6 shadow-[0_8px_30px_rgb(0,0,0,0.04)] border border-gray-50/50 space-y-5 shrink-0">
        <div className="space-y-2">
          <label className="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Tên đăng nhập hoặc Email</label>
          <div className="relative group">
            <div className="absolute left-3 top-1/2 -translate-y-1/2 w-9 h-9 bg-white rounded-full flex items-center justify-center shadow-sm">
               <UserIcon className="w-4.5 h-4.5 text-gray-400 group-focus-within:text-primary transition-colors" />
            </div>
            <input 
              type="text" 
              defaultValue="linhmuc@giaophan.org"
              className="w-full bg-[#f8fafc] border-2 border-transparent rounded-[18px] py-3.5 pl-14 pr-4 outline-none font-bold text-on-surface focus:bg-white focus:border-primary/20 transition-all text-sm"
            />
          </div>
        </div>

        <div className="space-y-2">
          <label className="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">Mật khẩu</label>
          <div className="relative group">
            <div className="absolute left-3 top-1/2 -translate-y-1/2 w-9 h-9 bg-white rounded-full flex items-center justify-center shadow-sm">
               <Lock className="w-4.5 h-4.5 text-gray-400 group-focus-within:text-primary transition-colors" />
            </div>
            <input 
              type="password" 
              defaultValue="password123"
              className="w-full bg-[#f8fafc] border-2 border-transparent rounded-[18px] py-3.5 pl-14 pr-12 outline-none font-bold text-on-surface focus:bg-white focus:border-primary/20 transition-all text-sm font-mono tracking-widest"
            />
            <button className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-400">
               <Eye className="w-4.5 h-4.5" />
            </button>
          </div>
        </div>

        <div className="flex justify-end pr-1">
          <button className="text-xs font-bold text-primary hover:underline transition-all">Quên mật khẩu?</button>
        </div>

        <button 
          onClick={onLogin}
          className="w-full bg-primary text-white py-4 rounded-[18px] font-black text-base shadow-xl shadow-primary/20 flex items-center justify-center gap-3 active:scale-95 transition-all group"
        >
          Đăng nhập
          <ArrowRight className="w-5 h-5 group-hover:translate-x-1 transition-transform" />
        </button>
      </div>

      {/* Alternative Login */}
      <div className="mt-8 mb-6 space-y-6 flex flex-col items-center shrink-0">
         <div className="relative w-full flex items-center justify-center">
            <div className="absolute inset-0 flex items-center">
               <div className="w-full border-t border-gray-100"></div>
            </div>
            <span className="relative px-6 bg-surface text-[9px] font-black text-gray-300 uppercase tracking-[0.2em]">Hoặc sử dụng thẻ tác vụ</span>
         </div>

         <button className="w-full bg-[#D97706] text-white py-4 rounded-[20px] font-black text-sm shadow-xl shadow-orange-100 flex items-center justify-center gap-3 active:scale-95 transition-all">
            <div className="w-9 h-9 bg-white/20 rounded-xl flex items-center justify-center">
               <Nfc className="w-5 h-5" />
            </div>
            Chạm thẻ Linh mục
         </button>
      </div>

      {/* Footer */}
      <div className="mt-auto flex flex-col items-center gap-3 shrink-0">
         <div className="h-[1px] w-full bg-gray-100/50 mb-1" />
         <p className="text-gray-400 font-bold text-xs">Không phải là Linh mục?</p>
         <button onClick={onBack} className="flex items-center gap-2 text-primary font-bold text-sm group">
            <ChevronRight className="w-4 h-4 rotate-180 group-hover:-translate-x-1 transition-transform" />
            Quay lại Trang chủ Giáo dân
         </button>
      </div>
    </div>
  );
};

const PriestHomeScreen = ({ onLogout, onProfileClick, onBiometricClick, onMassRequestClick, onNfcClick, onNotificationClick, onMyQrClick, onSearchClick, onBellClick, onHelpClick }: { onLogout: () => void, onProfileClick: () => void, onBiometricClick: () => void, onMassRequestClick: () => void, onNfcClick: () => void, onNotificationClick: () => void, onMyQrClick: () => void, onSearchClick: () => void, onBellClick: () => void, onHelpClick: () => void }) => {
  const liturgicalInfo = getLiturgicalData(new Date());

  return (
    <div className="flex flex-col gap-5 p-4 pb-32 bg-[#f8faff]">
      {/* Header */}
      <header className="flex justify-between items-center -mx-4 px-5 py-3 sticky top-0 z-40 bg-[#f8faff]/80 backdrop-blur-md">
        <div className="flex items-center gap-2">
           <AppLogo className="w-8 h-8 !rounded-lg" iconClassName="w-4.5 h-4.5" />
           <h1 className="text-sm font-display font-black text-primary uppercase tracking-wider">Thông tin Linh mục</h1>
        </div>
        <div className="flex items-center gap-2">
           <button onClick={onLogout} className="text-[10px] font-black text-gray-400 border border-gray-200 px-3 py-1.5 rounded-full hover:border-primary transition-colors">THOÁT</button>
           <button onClick={onBellClick} className="w-9 h-9 flex items-center justify-center text-primary relative">
              <Bell className="w-6 h-6" />
              <span className="absolute top-2 right-2 w-2 h-2 bg-red-500 rounded-full border-2 border-[#f8faff]" />
           </button>
        </div>
      </header>

      {/* Priest ID Card - New Design from Image */}
      <div className="bg-gradient-to-br from-[#0ea5e9] to-[#2563eb] rounded-[32px] p-5 shadow-xl shadow-blue-500/20 text-white relative overflow-hidden flex items-center justify-between">
          <div className="flex items-center gap-4 relative z-10">
             <div className="w-14 h-14 bg-white rounded-2xl flex items-center justify-center shadow-lg">
                <UserIcon className="w-8 h-8 text-blue-500" />
             </div>
             <div>
                <p className="text-[10px] font-black opacity-80 tracking-widest uppercase mb-0.5">Căn cước linh mục</p>
                <h2 className="text-base font-display font-black uppercase leading-tight">LM. PHAOLO</h2>
                <h3 className="text-xl font-display font-black leading-tight">HOÀNG MẠNH HUY</h3>
                <p className="text-[10px] font-bold opacity-70 mt-1 uppercase tracking-wider">Giáo phận Phú Cường</p>
             </div>
          </div>
          <button onClick={onProfileClick} className="relative z-20 bg-white/20 backdrop-blur-md px-3 py-2 rounded-2xl border border-white/30 flex flex-col items-center gap-0.5 active:scale-95 transition-all">
             <InfoIcon className="w-6 h-6 mb-0.5" />
             <span className="text-[8px] font-black tracking-widest">THÔNG TIN</span>
          </button>
          
          {/* Subtle patterns */}
          <div className="absolute -bottom-4 -right-4 w-32 h-32 bg-white/10 rounded-full blur-2xl" />
          <div className="absolute -top-4 -left-4 w-24 h-24 bg-white/5 rounded-full" />
      </div>

      {/* Action Bar - New Compact Style from Image */}
      <div className="bg-white rounded-[32px] p-5 shadow-sm border border-gray-100/50 flex justify-between items-center">
         <button onClick={onNfcClick} className="flex flex-col items-center gap-2">
            <div className="w-12 h-12 bg-orange-500 rounded-2xl flex items-center justify-center shadow-lg shadow-orange-500/30">
               <Nfc className="w-6 h-6 text-white" />
            </div>
            <span className="text-[11px] font-bold text-gray-600">Quét thẻ</span>
         </button>
         <button onClick={onMassRequestClick} className="flex flex-col items-center gap-2">
            <div className="w-12 h-12 bg-indigo-600 rounded-2xl flex items-center justify-center shadow-lg shadow-indigo-600/30">
               <Clock className="w-6 h-6 text-white" />
            </div>
            <span className="text-[11px] font-bold text-gray-600">Xin lễ</span>
         </button>
         <button onClick={onMyQrClick} className="flex flex-col items-center gap-2">
            <div className="w-12 h-12 bg-fuchsia-500 rounded-2xl flex items-center justify-center shadow-lg shadow-fuchsia-500/30">
               <QrCode className="w-6 h-6 text-white" />
            </div>
            <span className="text-[11px] font-bold text-gray-600">Mã QR</span>
         </button>
         <button onClick={onBiometricClick} className="flex flex-col items-center gap-2">
            <div className="w-12 h-12 bg-emerald-500 rounded-2xl flex items-center justify-center shadow-lg shadow-emerald-500/30">
               <Fingerprint className="w-6 h-6 text-white" />
            </div>
            <span className="text-[11px] font-bold text-gray-600">FaceID</span>
         </button>
      </div>

      {/* Request Card - Modern Notification Style from Image */}
      <div className="bg-white rounded-[24px] shadow-sm border border-gray-100 overflow-hidden relative">
         <div className="absolute left-0 top-0 bottom-0 w-1.5 bg-indigo-600" />
         <div className="p-4 pl-6">
            <div className="flex gap-4">
               <div className="w-10 h-10 shrink-0 bg-gray-50 border border-gray-100 rounded-xl flex items-center justify-center">
                  <Clock className="w-5 h-5 text-indigo-600" />
               </div>
               <p className="text-sm font-medium text-gray-800 leading-snug">
                  Linh mục <span className="font-extrabold text-indigo-900">Phaolo Hoàng Mạnh Huy</span> Giáo phận Phú Cường xin dâng lễ an táng.
               </p>
            </div>
            <div className="mt-4 flex items-center justify-between">
               <span className="text-[10px] font-black text-gray-300 uppercase tracking-widest">5 PHÚT TRƯỚC</span>
               <div className="flex gap-2">
                  <button 
                    onClick={onNotificationClick}
                    className="bg-gray-50 text-gray-500 px-4 py-2 rounded-xl text-xs font-bold border border-gray-100 active:scale-95 transition-all"
                  >CHI TIẾT</button>
                  <button className="bg-indigo-600 text-white px-4 py-2 rounded-xl text-xs font-bold flex items-center gap-1.5 shadow-lg shadow-indigo-100">
                     <Check className="w-4 h-4" />
                     DUYỆT
                  </button>
               </div>
            </div>
         </div>
      </div>

      <div className="mt-2 space-y-4">
         <h3 className="text-lg font-display font-black text-gray-900 ml-1">Tìm kiếm Linh mục</h3>
         <div className="bg-white rounded-[32px] p-5 shadow-sm border border-gray-100 space-y-3">
            <div className="relative group">
               <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300 group-focus-within:text-primary transition-colors" />
               <input 
                 type="text" 
                 placeholder="Nhập tên Linh mục..." 
                 className="w-full bg-[#f8faff] rounded-[20px] py-4 pl-12 pr-4 outline-none font-bold text-sm text-gray-800 focus:bg-white border-2 border-transparent focus:border-primary/5 transition-all" 
               />
            </div>
            <div className="relative group">
               <MapPin className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300 group-focus-within:text-primary transition-colors" />
               <select className="w-full bg-[#f8faff] rounded-[20px] py-4 pl-12 pr-10 outline-none font-bold text-sm text-gray-800 appearance-none focus:bg-white border-2 border-transparent focus:border-primary/5 transition-all">
                  <option>Chọn Giáo phận</option>
                  <option>Phú Cường</option>
                  <option>Sài Gòn</option>
                  <option>Hà Nội</option>
               </select>
               <ChevronDown className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-300 w-5 h-5" />
            </div>
            <button onClick={onSearchClick} className="w-full bg-primary text-white py-4 rounded-[20px] font-black text-sm shadow-xl shadow-primary/10 flex items-center justify-center gap-2 active:scale-95 transition-all mt-1">
               <Search className="w-4 h-4" />
               TÌM KIẾM
            </button>
         </div>
      </div>

      {/* Liturgical Day Info - NEW SECTION */}
      <div className="bg-white rounded-[24px] shadow-sm border border-gray-100 overflow-hidden">
         <div className="bg-gradient-to-r from-emerald-500/10 via-emerald-500/5 to-transparent p-4 flex items-center justify-between border-b border-emerald-100/50">
            <div className="flex items-center gap-3">
               <div className="w-10 h-10 bg-emerald-100 rounded-xl flex items-center justify-center text-emerald-600 shadow-sm border border-emerald-200/50">
                  <Calendar className="w-5 h-5" />
               </div>
               <div>
                  <h4 className="text-[10px] font-black text-emerald-600 uppercase tracking-widest leading-tight">Ngày Phụng vụ</h4>
                  <p className="text-sm font-black text-gray-800">{liturgicalInfo.dateString}</p>
               </div>
            </div>
            <div className="px-3 py-1 bg-emerald-50 text-emerald-700 rounded-lg text-[9px] font-black border border-emerald-100 uppercase tracking-wider">
               {liturgicalInfo.season}
            </div>
         </div>
         
         <div className="p-4 space-y-3">
            {/* Saint/Feast */}
            <div className="flex items-start gap-3 bg-gray-50/50 p-2.5 rounded-xl border border-gray-100/50">
               <div className="w-8 h-8 rounded-lg bg-amber-100 flex items-center justify-center text-amber-600 shrink-0">
                  <Star className="w-4 h-4 fill-amber-600" />
               </div>
               <div>
                  <p className="text-[9px] font-black text-amber-500 uppercase tracking-wider mb-0.5">Lễ kính / Kỷ niệm</p>
                  <p className="text-[11px] font-bold text-gray-700">{liturgicalInfo.feast}</p>
               </div>
            </div>

            {/* Readings */}
            <div className="grid grid-cols-1 gap-2.5">
               {liturgicalInfo.readings.map((reading, idx) => (
                 <div key={idx} className="flex items-center justify-between p-2 rounded-xl hover:bg-gray-50 transition-colors border border-transparent hover:border-gray-100">
                    <div className="flex items-center gap-3">
                       <div className={`w-7 h-7 rounded-lg ${reading.color} flex items-center justify-center ${reading.iconColor}`}>
                          <reading.icon className="w-3.5 h-3.5" />
                       </div>
                       <span className="text-[11px] font-bold text-gray-600">{reading.label}</span>
                    </div>
                    <span className="text-[11px] font-black text-primary px-2 py-0.5 bg-primary/5 rounded-md">{reading.text}</span>
                 </div>
               ))}
            </div>
         </div>
      </div>

      {/* Help Link */}
      <button onClick={onHelpClick} className="flex items-center justify-center gap-2 py-4 text-primary font-bold text-sm opacity-60 hover:opacity-100 transition-opacity">
         <HelpCircle className="w-4 h-4" />
         Hướng dẫn sử dụng Căn cước Linh mục
      </button>
    </div>
  );
};

const HistoryScreen = () => {
  const [activeFilter, setActiveFilter] = useState('Tất cả');
  const filters = ['Tất cả', 'Cập nhật', 'Dâng lễ', 'Đóng góp'];

  const historyItems = [
    {
      id: 1,
      type: 'Cập nhật',
      title: 'Yêu cầu cập nhật thông tin',
      status: 'Đã hoàn thành',
      date: '20/10/2023',
      icon: UserCog,
      color: 'border-l-emerald-500',
      statusColor: 'text-emerald-600 bg-emerald-50',
    },
    {
      id: 2,
      type: 'Dâng lễ',
      title: 'Xin dâng lễ tạ ơn',
      status: 'Đang xử lý',
      date: '18/10/2023',
      icon: Church,
      color: 'border-l-orange-500',
      statusColor: 'text-orange-600 bg-orange-50',
    },
    {
      id: 3,
      type: 'Cập nhật',
      title: 'Yêu cầu cập nhật thông tin',
      status: 'Đã từ chối',
      date: '15/10/2023',
      icon: Undo2,
      color: 'border-l-red-500',
      statusColor: 'text-red-600 bg-red-50',
    },
    {
      id: 4,
      type: 'Dâng lễ',
      title: 'Xin dâng lễ cầu bình an',
      status: 'Đã hoàn thành',
      date: '10/10/2023',
      icon: Church,
      color: 'border-l-emerald-500',
      statusColor: 'text-emerald-600 bg-emerald-50',
    },
  ];

  return (
    <div className="flex flex-col min-h-full bg-[#f8faff] pb-32">
       {/* Header */}
       <header className="flex justify-between items-center px-4 py-3 sticky top-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-100">
          <button className="p-2 text-primary">
             <Menu className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-display font-black text-primary tracking-tight">Sacred Link</h1>
          <button className="p-2 text-primary">
             <Search className="w-6 h-6" />
          </button>
       </header>

       <div className="p-4 space-y-6 overflow-x-hidden">
          {/* Page Title */}
          <div>
             <h2 className="text-2xl font-display font-black text-gray-900 leading-tight">Lịch sử hoạt động</h2>
             <p className="text-sm font-bold text-gray-400 mt-1">Theo dõi các yêu cầu và cập nhật của bạn.</p>
          </div>

          {/* Search Bar */}
          <div className="relative group">
             <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300 group-focus-within:text-primary transition-colors" />
             <input 
               type="text" 
               placeholder="Tìm kiếm lịch sử..." 
               className="w-full bg-white rounded-[20px] py-4 pl-12 pr-4 outline-none font-bold text-sm text-gray-800 border-2 border-transparent focus:border-primary/10 shadow-sm transition-all"
             />
          </div>

          {/* Filters */}
          <div className="flex gap-2 overflow-x-auto no-scrollbar -mx-4 px-4">
             {filters.map((filter) => (activeFilter === filter) ? (
                <button
                   key={filter}
                   className="px-6 py-2.5 rounded-full text-xs font-black bg-primary text-white shadow-lg shadow-primary/20 scale-105 transition-all whitespace-nowrap"
                >
                   {filter}
                </button>
             ) : (
                <button
                   key={filter}
                   onClick={() => setActiveFilter(filter)}
                   className="px-6 py-2.5 rounded-full text-xs font-black bg-white text-gray-400 border border-gray-100 hover:bg-gray-50 transition-all whitespace-nowrap"
                >
                   {filter}
                </button>
             ))}
          </div>

          {/* List */}
          <div className="space-y-4">
             {historyItems.map((item) => (
                <motion.div 
                  key={item.id}
                  whileHover={{ x: 4 }}
                  className={`bg-white rounded-[24px] p-4 shadow-sm border border-gray-50 border-l-[6px] ${item.color} flex items-center gap-4 cursor-pointer`}
                >
                   <div className="w-12 h-12 rounded-2xl bg-gray-50 flex items-center justify-center text-gray-400">
                      <item.icon className="w-6 h-6" />
                   </div>
                   <div className="flex-1 min-w-0">
                      <h4 className="text-[15px] font-black text-gray-800 truncate mb-1">{item.title}</h4>
                      <div className="flex items-center gap-2">
                         <span className={`px-2.5 py-0.5 rounded-full text-[10px] font-black uppercase tracking-wider ${item.statusColor}`}>
                            {item.status}
                         </span>
                         <span className="text-[10px] font-bold text-gray-300 uppercase tracking-widest">• {item.date}</span>
                      </div>
                   </div>
                   <ChevronRight className="w-5 h-5 text-gray-300" />
                </motion.div>
             ))}
          </div>
       </div>
    </div>
  );
};

const SettingsScreen = ({ onBellClick }: { onBellClick: () => void }) => {
  const settingsGroups = [
    {
      title: 'Tài khoản & Bảo mật',
      items: [
        { icon: UserIcon, label: 'Thông tin cá nhân', color: 'text-blue-600', bgColor: 'bg-blue-50' },
        { icon: Fingerprint, label: 'Sinh trắc học', color: 'text-orange-600', bgColor: 'bg-orange-50' },
        { icon: Lock, label: 'Đổi mật khẩu', color: 'text-red-600', bgColor: 'bg-red-50' },
      ]
    },
    {
      title: 'Ứng dụng & Hỗ trợ',
      items: [
        { icon: Languages, label: 'Ngôn ngữ', color: 'text-emerald-600', bgColor: 'bg-emerald-50' },
        { icon: Undo2, label: 'Đề nghị cập nhật', color: 'text-indigo-600', bgColor: 'bg-indigo-50' },
        { icon: HelpCircle, label: 'Hỗ trợ', color: 'text-amber-600', bgColor: 'bg-amber-50' },
      ]
    }
  ];

  return (
    <div className="flex flex-col min-h-full bg-[#f8faff] pb-32">
       {/* Header */}
       <header className="flex justify-between items-center px-4 py-3 sticky top-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-100">
          <div className="w-10"></div>
          <h1 className="text-xl font-display font-black text-primary tracking-tight">Cài đặt</h1>
          <button onClick={onBellClick} className="p-2 text-primary">
             <Bell className="w-6 h-6" />
          </button>
       </header>

       <div className="p-4 space-y-8">
          {/* Profile Quick Summary */}
          <div className="bg-white rounded-[32px] p-6 shadow-sm border border-gray-50 flex items-center gap-4">
             <div className="w-16 h-16 rounded-2xl overflow-hidden bg-gray-100 border-2 border-white shadow-md">
                <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuAGmWxIVRZHVY7sZx9oNTNW9sV-enLy9YHyVPr-YRyTC4Vh6W_vmM2iDr1MD-CjemRbQACN9AAJ89iVpX3iHMBpP4GGL3a6piruosdhoQUUHTRPhlVWaKVNaHF8ANPbA9YUry1cGQS_jKFqI0UTjdy6_aYS5HyPXG40xuBs3O4il6AEKAGcxaeqzev1PRXYCDlSbDyswI3Z2mXxUwu9plX7-SPrJX-fD6vVa4QTxtxUNwB7i5sXy9uVOcmOvi_nqNb7-epUpvMR-K65" className="w-full h-full object-cover" />
             </div>
             <div>
                <h3 className="text-lg font-black text-gray-800 leading-tight">LM. Phaolô Hoàng Mạnh Huy</h3>
                <p className="text-[10px] font-black text-blue-600 uppercase tracking-widest mt-1">Giáo phận Phú Cường</p>
             </div>
          </div>

          {settingsGroups.map((group, gIdx) => (
             <div key={gIdx} className="space-y-3">
                <h4 className="text-[10px] font-black text-gray-400 uppercase tracking-widest ml-1">{group.title}</h4>
                <div className="bg-white rounded-[32px] overflow-hidden shadow-sm border border-gray-50">
                   {group.items.map((item, iIdx) => (
                      <button 
                        key={iIdx}
                        className="w-full flex items-center justify-between p-4 hover:bg-gray-50 transition-all border-b last:border-0 border-gray-50 active:scale-[0.99]"
                      >
                         <div className="flex items-center gap-4">
                            <div className={`w-10 h-10 rounded-2xl ${item.bgColor} flex items-center justify-center ${item.color}`}>
                               <item.icon className="w-5 h-5" />
                            </div>
                            <span className="text-sm font-black text-gray-700">{item.label}</span>
                         </div>
                         <ChevronRight className="w-5 h-5 text-gray-300" />
                      </button>
                   ))}
                </div>
             </div>
          ))}

          {/* Logout Button */}
          <button className="w-full flex items-center justify-center gap-2 py-4 text-red-500 font-black text-sm hover:bg-red-50 rounded-[20px] transition-all border-2 border-transparent hover:border-red-100">
             <LogOut className="w-5 h-5" />
             ĐĂNG XUẤT
          </button>

          <div className="pt-4 pb-8 text-center">
             <p className="text-[10px] font-black text-gray-300 uppercase tracking-[0.3em]">Sacred Link v1.0.4</p>
             <p className="text-[10px] font-bold text-gray-200 mt-1">Copyright © 2024 Digital Ecclesia</p>
          </div>
       </div>
    </div>
  );
};

const NotificationsScreen = ({ onBack }: { onBack: () => void }) => {
  const notifications = [
    {
      id: 1,
      title: 'Yêu cầu dâng lễ mới',
      content: 'Linh mục Phaolô Hoàng Mạnh Huy gửi yêu cầu dâng lễ an táng.',
      time: '5 phút trước',
      isRead: false,
      type: 'mass'
    },
    {
      id: 2,
      title: 'Cập nhật hệ thống',
      content: 'Hệ thống Sacred Link đã được cập nhật lên phiên bản 1.0.4.',
      time: '2 giờ trước',
      isRead: true,
      type: 'system'
    },
    {
      id: 3,
      title: 'Nhắc lịch công tác',
      content: 'Ngày mai bạn có buổi dâng lễ tại Giáo xứ Tân Định lúc 08:00.',
      time: '1 ngày trước',
      isRead: true,
      type: 'calendar'
    },
    {
      id: 4,
      title: 'Yêu cầu cập nhật thông tin',
      content: 'Văn phòng Giáo phận yêu cầu bạn cập nhật học vị mới.',
      time: '3 ngày trước',
      isRead: true,
      type: 'profile'
    }
  ];

  return (
    <div className="flex flex-col min-h-full bg-[#f8faff] pb-32">
       <header className="flex justify-between items-center px-4 py-3 sticky top-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-100">
          <button onClick={onBack} className="p-2 text-primary">
             <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-display font-black text-primary tracking-tight">Thông báo</h1>
          <button className="p-2 text-primary">
             <MoreVertical className="w-6 h-6" />
          </button>
       </header>

       <div className="p-4 space-y-4">
          <div className="flex justify-between items-center px-1">
             <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Mới nhất</span>
             <button className="text-xs font-bold text-primary">Đánh dấu đã đọc tất cả</button>
          </div>

          <div className="space-y-3">
             {notifications.map((notif) => (
                <div 
                  key={notif.id}
                  className={`bg-white rounded-[24px] p-4 shadow-sm border border-gray-50 flex gap-4 relative overflow-hidden transition-all active:scale-[0.98] ${!notif.isRead ? 'ring-2 ring-primary/5' : ''}`}
                >
                   {!notif.isRead && (
                      <div className="absolute right-4 top-4 w-2 h-2 bg-blue-500 rounded-full" />
                   )}
                   <div className={`w-12 h-12 rounded-2xl shrink-0 flex items-center justify-center ${
                      notif.type === 'mass' ? 'bg-indigo-50 text-indigo-600' :
                      notif.type === 'system' ? 'bg-emerald-50 text-emerald-600' :
                      notif.type === 'calendar' ? 'bg-amber-50 text-amber-600' :
                      'bg-blue-50 text-blue-600'
                   }`}>
                      {notif.type === 'mass' ? <Clock className="w-6 h-6" /> :
                       notif.type === 'system' ? <Verified className="w-6 h-6" /> :
                       notif.type === 'calendar' ? <Calendar className="w-6 h-6" /> :
                       <UserIcon className="w-6 h-6" />}
                   </div>
                   <div className="flex-1">
                      <h4 className={`text-sm font-black mb-1 ${notif.isRead ? 'text-gray-700' : 'text-gray-900'}`}>{notif.title}</h4>
                      <p className="text-xs text-gray-500 font-medium leading-relaxed">{notif.content}</p>
                      <span className="text-[10px] font-bold text-gray-300 uppercase tracking-widest mt-2 block">{notif.time}</span>
                   </div>
                </div>
             ))}
          </div>
       </div>
    </div>
  );
};

const MyQrScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <div className="flex flex-col min-h-full bg-[#f8faff] pb-32">
       {/* Header */}
       <header className="flex justify-between items-center px-4 py-3 sticky top-0 z-50 bg-white/95 backdrop-blur-md border-b border-gray-100">
          <button onClick={onBack} className="p-2 text-primary active:scale-90 transition-transform">
             <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-display font-black text-primary tracking-tight">Mã QR Định danh</h1>
          <button className="p-2 text-primary active:scale-90 transition-transform">
             <Share2 className="w-6 h-6" />
          </button>
       </header>

       <div className="flex-1 flex flex-col items-center justify-center p-6 gap-8">
          <div className="bg-white rounded-[48px] p-8 shadow-2xl shadow-primary/10 border border-gray-100 relative group">
             {/* Decorative Corners */}
             <div className="absolute top-6 left-6 w-8 h-8 border-t-4 border-l-4 border-primary rounded-tl-xl" />
             <div className="absolute top-6 right-6 w-8 h-8 border-t-4 border-r-4 border-primary rounded-tr-xl" />
             <div className="absolute bottom-6 left-6 w-8 h-8 border-b-4 border-l-4 border-primary rounded-bl-xl" />
             <div className="absolute bottom-6 right-6 w-8 h-8 border-b-4 border-r-4 border-primary rounded-br-xl" />

             <div className="p-4 bg-gray-50 rounded-[32px]">
                <QRCodeCanvas 
                   value="https://sacredlink.church/priest/hoangmanhhuy" 
                   size={220}
                   level="H"
                   includeMargin={true}
                   imageSettings={{
                     src: "https://ais-dev-ky6ihea6wkmx2xem6howoi-537691938664.asia-southeast1.run.app/favicon.ico",
                     x: undefined,
                     y: undefined,
                     height: 48,
                     width: 48,
                     excavate: true,
                   }}
                />
             </div>
          </div>

          <div className="text-center space-y-2">
             <div className="flex items-center justify-center gap-1.5 mb-1">
                <div className="w-2 h-2 bg-emerald-500 rounded-full animate-pulse" />
                <span className="text-[10px] font-black text-emerald-600 uppercase tracking-widest">Đã xác thực danh tính</span>
             </div>
             <h2 className="text-2xl font-display font-black text-gray-900 uppercase tracking-tight">LM. PHAOLÔ</h2>
             <h3 className="text-3xl font-display font-black text-primary leading-none uppercase">HOÀNG MẠNH HUY</h3>
             <p className="text-xs font-bold text-gray-400 mt-2">Mã định danh: <span className="text-gray-600">SL-PC-12051980</span></p>
          </div>

          <div className="grid grid-cols-2 gap-4 w-full max-w-sm">
             <button className="flex items-center justify-center gap-2 bg-white text-gray-700 py-4 rounded-2xl font-black text-xs uppercase tracking-widest shadow-sm border border-gray-100 active:scale-95 transition-all">
                <Download className="w-4 h-4" />
                Lưu ảnh
             </button>
             <button className="flex items-center justify-center gap-2 bg-primary text-white py-4 rounded-2xl font-black text-xs uppercase tracking-widest shadow-lg shadow-primary/20 active:scale-95 transition-all">
                <Share2 className="w-4 h-4" />
                Chia sẻ
             </button>
          </div>

          <p className="text-[10px] font-bold text-gray-400 text-center max-w-[200px] leading-relaxed uppercase tracking-widest">
             Sử dụng mã QR này để điểm danh hoặc chia sẻ thông tin mục vụ chính thức.
          </p>
       </div>
    </div>
  );
};

const PriestHelpScreen = ({ onBack }: { onBack: () => void }) => {
  const helpItems = [
    {
      icon: Nfc,
      title: 'Xác thực NFC',
      description: 'Công nghệ bảo mật cao nhất bằng cách chạm thẻ linh mục vào mặt sau điện thoại để xác thực danh tính chính thức.',
      color: 'bg-orange-50 text-orange-600'
    },
    {
      icon: QrCode,
      title: 'Mã QR Định danh',
      description: 'Mỗi linh mục có một mã QR riêng. Quét mã để chia sẻ thông tin liên lạc nhanh chóng hoặc điểm danh tại các sự kiện giáo hội.',
      color: 'bg-fuchsia-50 text-fuchsia-600'
    },
    {
      icon: Clock,
      title: 'Quản lý Xin lễ',
      description: 'Gửi yêu cầu dâng lễ trực tuyến đến văn phòng giáo phận hoặc nhận và duyệt các yêu cầu dâng lễ từ giáo dân gửi đến.',
      color: 'bg-indigo-50 text-indigo-600'
    },
    {
      icon: Bell,
      title: 'Hệ thống Thông báo',
      description: 'Luôn cập nhật các thông báo khẩn, nhắc lịch công tác và tin tức quan trọng từ Giáo phận thông qua trung tâm thông báo.',
      color: 'bg-blue-50 text-blue-600'
    },
    {
      icon: Search,
      title: 'Tìm kiếm Linh mục',
      description: 'Dễ dàng tra cứu thông tin liên lạc và chức vụ của các linh mục trong hệ thống Digital Ecclesia toàn quốc.',
      color: 'bg-slate-50 text-slate-600'
    },
    {
      icon: Fingerprint,
      title: 'Bảo mật Sinh trắc học',
      description: 'Sử dụng FaceID hoặc Fingerprint để bảo vệ ứng dụng, đảm bảo chỉ chính chủ mới có thể truy cập thông tin nhạy cảm.',
      color: 'bg-emerald-50 text-emerald-600'
    }
  ];

  return (
    <div className="flex flex-col min-h-full bg-[#f8faff] pb-32">
       <header className="flex justify-between items-center px-4 py-3 sticky top-0 z-50 bg-white shadow-sm border-b border-gray-100">
          <button onClick={onBack} className="p-2 text-primary">
             <ArrowLeft className="w-6 h-6" />
          </button>
          <div className="flex-1 text-center pr-10">
             <h1 className="text-xl font-display font-black text-primary tracking-tight">Hướng dẫn sử dụng</h1>
          </div>
       </header>

       <div className="p-5 space-y-6">
          <div className="bg-white rounded-[32px] p-6 shadow-sm border border-gray-50">
             <h3 className="text-lg font-black text-gray-800 mb-2">Chào mừng Linh mục,</h3>
             <p className="text-sm text-gray-500 font-medium leading-relaxed">
                Hệ thống Căn cước Linh mục kỹ thuật số giúp việc quản lý mục vụ và kết nối trong giáo hội trở nên thuận tiện và bảo mật hơn bao giờ hết.
             </p>
          </div>

          <div className="grid gap-4">
             {helpItems.map((item, idx) => (
                <div key={idx} className="bg-white rounded-[28px] p-5 shadow-sm border border-gray-50 flex items-start gap-4">
                   <div className={`w-12 h-12 rounded-2xl shrink-0 flex items-center justify-center ${item.color}`}>
                      <item.icon className="w-6 h-6" />
                   </div>
                   <div>
                      <h4 className="text-sm font-black text-gray-800 mb-1">{item.title}</h4>
                      <p className="text-xs text-gray-500 font-medium leading-relaxed">{item.description}</p>
                   </div>
                </div>
             ))}
          </div>

          <div className="bg-primary/5 rounded-[32px] p-6 border border-primary/10">
             <h4 className="text-xs font-black text-primary uppercase tracking-widest mb-2">Cần hỗ trợ thêm?</h4>
             <p className="text-xs text-gray-600 font-medium leading-relaxed mb-4">
                Nếu vị cần được hướng dẫn trực tiếp hoặc gặp sự cố kỹ thuật, vui lòng liên hệ Ban Truyền thông Giáo phận.
             </p>
             <button className="w-full bg-primary text-white py-3 rounded-2xl font-black text-xs uppercase tracking-widest shadow-lg shadow-primary/20">
                GỬI YÊU CẦU HỖ TRỢ
             </button>
          </div>
       </div>
    </div>
  );
};

const MassRequestDetailScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <div className="absolute inset-0 bg-[#f6f8fb] z-[60] flex flex-col h-full overflow-hidden">
       {/* Header */}
       <header className="flex items-center px-4 py-3 sticky top-0 z-50 bg-white shadow-sm border-b border-gray-100">
          <button onClick={onBack} className="p-2 text-blue-600">
             <ArrowLeft className="w-6 h-6" />
          </button>
          <div className="flex-1 text-center pr-10">
             <h1 className="text-xl font-display font-black text-blue-800 tracking-tight">Chi tiết yêu cầu</h1>
          </div>
       </header>

       <div className="flex-1 overflow-y-auto p-4 space-y-5 pb-32">
          {/* Status Badge */}
          <div className="flex justify-center py-2">
             <div className="inline-flex items-center gap-2 bg-blue-100/50 text-blue-700 px-4 py-2 rounded-full border border-blue-100 shadow-sm">
                <Sparkles className="w-4 h-4" />
                <span className="text-[10px] font-black uppercase tracking-widest">Yêu cầu mới</span>
             </div>
          </div>
          <p className="text-center text-xs font-bold text-gray-400 -mt-2">Yêu cầu dâng lễ từ linh mục khác cần được duyệt.</p>

          {/* Section: Sender Info */}
          <section className="bg-white rounded-[32px] p-6 shadow-sm border border-gray-100 space-y-4">
             <div className="flex items-center gap-2 mb-2">
                <div className="w-8 h-8 rounded-xl bg-gray-50 flex items-center justify-center text-gray-400">
                   <UserIcon className="w-4 h-4" />
                </div>
                <h4 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">THÔNG TIN LINH MỤC GỬI YÊU CẦU</h4>
             </div>
             
             <div className="flex items-center gap-4 p-1">
                <div className="w-14 h-14 bg-gray-100 rounded-full flex items-center justify-center border-4 border-white shadow-sm">
                   <UserIcon className="w-8 h-8 text-gray-400" />
                </div>
                <div>
                   <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none mb-1">Tên thánh & Họ tên</p>
                   <p className="text-lg font-black text-gray-800">Phaolô Nguyễn Văn A</p>
                </div>
             </div>

             <div className="grid grid-cols-1 gap-4 pt-2">
                <div className="flex items-start gap-3">
                   <Church className="w-4 h-4 text-gray-300 mt-1" />
                   <div>
                      <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none mb-1">Giáo xứ hiện tại</p>
                      <p className="text-sm font-bold text-gray-700">Giáo xứ Thánh Đa Minh, TGP Sài Gòn</p>
                   </div>
                </div>
                <div className="flex items-start gap-3">
                   <MapPin className="w-4 h-4 text-gray-300 mt-1" />
                   <div>
                      <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none mb-1">Số điện thoại liên hệ</p>
                      <p className="text-sm font-bold text-gray-700">090 123 4567</p>
                   </div>
                </div>
             </div>
          </section>

          {/* Section: Mass Details */}
          <section className="bg-white rounded-[32px] p-6 shadow-sm border border-gray-100 space-y-6">
             <div className="flex items-center gap-2 mb-2">
                <div className="w-8 h-8 rounded-xl bg-gray-50 flex items-center justify-center text-gray-400">
                   <ListFilter className="w-4 h-4" />
                </div>
                <h4 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">CHI TIẾT DÂNG LỄ</h4>
             </div>

             <div className="p-4 bg-orange-50 border-l-4 border-orange-400 rounded-r-2xl">
                <p className="text-[10px] font-black text-orange-400 uppercase tracking-widest mb-1">Loại lễ</p>
                <p className="text-lg font-black text-orange-950">Lễ Cầu Hồn</p>
             </div>

             <div className="flex items-center gap-4">
                <div className="w-12 h-12 bg-blue-50 rounded-2xl flex items-center justify-center text-blue-600">
                   <Calendar className="w-6 h-6" />
                </div>
                <div>
                   <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none mb-1">Thời gian dự kiến</p>
                   <p className="text-sm font-black text-gray-800">18:00 - Thứ Sáu, 24/11/2023</p>
                </div>
             </div>

             <div className="space-y-2">
                <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Ý chỉ / Ghi chú</p>
                <div className="bg-gray-50 rounded-2xl p-4 relative overflow-hidden">
                   <div className="absolute top-2 right-4 text-blue-100 opacity-50">
                      <Sparkles className="w-8 h-8 rotate-12" />
                   </div>
                   <p className="text-sm font-bold text-gray-600 italic relative z-10 leading-relaxed">
                      "Cầu cho linh hồn Maria mới qua đời. Xin cha dâng lễ sốt sắng."
                   </p>
                </div>
             </div>

          </section>
       </div>

       {/* Bottom Actions Overlay */}
       <div className="absolute bottom-0 w-full p-6 bg-white/80 backdrop-blur-md border-t border-gray-100 flex gap-4 pb-10">
          <button className="flex-1 h-14 flex items-center justify-center rounded-2xl border-2 border-gray-200 text-gray-600 font-black text-sm active:bg-gray-50 transition-all gap-2">
             <X className="w-5 h-5" strokeWidth={3} />
             Từ chối
          </button>
          <button className="flex-1 h-14 flex items-center justify-center rounded-2xl bg-blue-600 shadow-xl shadow-blue-200 text-white font-black text-sm active:scale-[0.98] transition-all gap-2">
             <Check className="w-5 h-5" strokeWidth={3} />
             Duyệt yêu cầu
          </button>
       </div>
    </div>
  );
};

const SearchDetailScreen = ({ onBack }: { onBack: () => void }) => {
  return (
    <div className="flex flex-col min-h-full bg-[#f8faff] pb-32">
       {/* Header */}
       <header className="flex justify-between items-center px-4 py-3 sticky top-0 z-50 bg-white shadow-sm border-b border-gray-100">
          <button onClick={onBack} className="p-2 text-primary">
             <ArrowLeft className="w-6 h-6" />
          </button>
          <div className="flex-1 text-center pr-10">
             <h1 className="text-xl font-display font-black text-primary tracking-tight">Kết quả tìm kiếm</h1>
          </div>
       </header>

       <div className="p-4 space-y-6">
          {/* Profile Card */}
          <div className="bg-white rounded-[32px] p-6 shadow-sm border border-gray-50 flex flex-col items-center gap-4">
             <div className="w-24 h-24 rounded-3xl overflow-hidden bg-gray-100 border-4 border-white shadow-md">
                <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuC6TC9vRUUgKI9T11hymO9XUCZRVVb69CUZXLKtVxoIHEuEfhl1s_2yYGFO-mMbl9c7RcVXdttqm3yrTWvxu1emm73FSoTyD7N0ue9KINtZ8ZJKV4QubADC1F3e0EB9k7qkZNyaUAMeYorTNXwrUCaleP8FeQ7Yw8pu-1SpPVTYYsA-eg69xRVA9yvpR8pIKAkvIM-faPi1gAula_lRAhHiyMSjCB3zlhyo1U7zTzWRanI9zZe0kMgK0Kcxs4WBdRcAVEcrZZZl_Gx-" className="w-full h-full object-cover" />
             </div>
             <div className="text-center">
                <h3 className="text-xl font-black text-gray-800 leading-tight">LM. Giuse Trần Văn Huy</h3>
                <p className="text-[10px] font-black text-primary uppercase tracking-widest mt-1">Tổng Giáo Phận Hà Nội</p>
                <div className="mt-3 inline-flex items-center gap-2 bg-emerald-50 text-emerald-600 px-3 py-1 rounded-full text-[9px] font-black uppercase tracking-wider border border-emerald-100">
                   <div className="w-2 h-2 bg-emerald-500 rounded-full" />
                   Đang hoạt động
                </div>
             </div>
          </div>

          {/* Info Sections - similar style to MassRequestDetailScreen but for Priest info */}
          <section className="bg-white rounded-[32px] p-6 shadow-sm border border-gray-100 space-y-4">
             <div className="flex items-center gap-2 mb-2">
                <div className="w-8 h-8 rounded-xl bg-gray-50 flex items-center justify-center text-gray-400">
                   <UserIcon className="w-4 h-4" />
                </div>
                <h4 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">THÔNG TIN CƠ BẢN</h4>
             </div>
             
             <div className="grid grid-cols-1 gap-4">
                <div className="flex items-start gap-4">
                   <div className="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center text-blue-600 shrink-0">
                      <Calendar className="w-5 h-5" />
                   </div>
                   <div>
                      <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none mb-1">Ngày sinh & Thụ phong</p>
                      <p className="text-sm font-bold text-gray-700">12/05/1980 — Thụ phong: 20/06/2008</p>
                   </div>
                </div>
                
                <div className="flex items-start gap-4">
                   <div className="w-10 h-10 bg-indigo-50 rounded-xl flex items-center justify-center text-indigo-600 shrink-0">
                      <Church className="w-5 h-5" />
                   </div>
                   <div>
                      <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none mb-1">Giáo xứ hiện tại</p>
                      <p className="text-sm font-bold text-gray-700">Giáo xứ Hàm Long, Q. Hoàn Kiếm, Hà Nội</p>
                   </div>
                </div>

                <div className="flex items-start gap-4">
                   <div className="w-10 h-10 bg-emerald-50 rounded-xl flex items-center justify-center text-emerald-600 shrink-0">
                      <GraduationCap className="w-5 h-5" />
                   </div>
                   <div>
                      <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest leading-none mb-1">Học vị</p>
                      <p className="text-sm font-bold text-gray-700">Thạc sĩ Mục vụ Giáo hội</p>
                   </div>
                </div>
             </div>
          </section>

          {/* Action Buttons to connect */}
          <div className="grid grid-cols-2 gap-4">
             <button className="flex flex-col items-center justify-center p-5 bg-white rounded-[32px] shadow-sm border border-gray-50 gap-2 active:scale-95 transition-all">
                <div className="w-12 h-12 bg-blue-100 rounded-2xl flex items-center justify-center text-blue-600">
                   <Phone className="w-6 h-6" />
                </div>
                <span className="text-[11px] font-black text-gray-600 uppercase tracking-wider">Gọi điện</span>
             </button>
             <button className="flex flex-col items-center justify-center p-5 bg-white rounded-[32px] shadow-sm border border-gray-50 gap-2 active:scale-95 transition-all">
                <div className="w-12 h-12 bg-indigo-100 rounded-2xl flex items-center justify-center text-indigo-600">
                   <Mail className="w-6 h-6" />
                </div>
                <span className="text-[11px] font-black text-gray-600 uppercase tracking-wider">Gửi Email</span>
             </button>
          </div>
       </div>
    </div>
  );
};

const MassRequestScreen = ({ onBack }: { onBack: () => void }) => {
  const [selectedType, setSelectedType] = useState('Tạ ơn');
  const massTypes = ['Tạ ơn', 'Cầu bình an', 'An táng', 'Hôn phối', 'Khác'];

  return (
    <div className="flex flex-col min-h-full bg-[#f6fafe] pb-32">
       {/* Header */}
       <header className="flex items-center px-4 py-3 sticky top-0 z-50 bg-white shadow-sm border-b border-gray-100">
          <button onClick={onBack} className="p-2 text-blue-600">
             <ArrowLeft className="w-6 h-6" />
          </button>
          <div className="flex-1 text-center pr-10">
             <h1 className="text-xl font-display font-black text-gray-900 tracking-tight">Xin dâng lễ</h1>
             <p className="text-[10px] font-bold text-gray-400 mt-0.5">Gửi yêu cầu xin dâng thánh lễ</p>
          </div>
       </header>

       <div className="p-4 space-y-5 mt-2">
          {/* Section: Mass Type */}
          <section className="bg-white rounded-[28px] p-6 shadow-sm border border-gray-100">
             <div className="flex items-center gap-2 mb-4">
                <div className="w-8 h-8 rounded-xl bg-blue-50 flex items-center justify-center text-blue-600">
                   <ListFilter className="w-4 h-4" />
                </div>
                <h4 className="text-xs font-black text-gray-400 uppercase tracking-widest">Loại lễ</h4>
             </div>
             <div className="flex flex-wrap gap-2">
                {massTypes.map((type) => (
                   <button
                      key={type}
                      onClick={() => setSelectedType(type)}
                      className={`px-5 py-2.5 rounded-full text-xs font-black transition-all ${
                         selectedType === type
                            ? 'bg-blue-600 text-white shadow-lg shadow-blue-200 scale-105'
                            : 'bg-gray-50 text-gray-400 border border-gray-100 hover:bg-gray-100'
                      }`}
                   >
                      {type}
                   </button>
                ))}
             </div>
          </section>

          {/* Section: Parish Selection */}
          <section className="bg-white rounded-[28px] p-6 shadow-sm border border-gray-100 space-y-4">
             <div className="flex items-center gap-2 mb-1">
                <div className="w-8 h-8 rounded-xl bg-blue-50 flex items-center justify-center text-blue-600">
                   <Church className="w-4 h-4" />
                </div>
                <h4 className="text-xs font-black text-gray-400 uppercase tracking-widest">Chọn Giáo xứ</h4>
             </div>
             
             <div className="relative group">
                <MapPin className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300 group-focus-within:text-blue-500 transition-colors" />
                <select className="w-full bg-gray-50 rounded-2xl py-4 pl-12 pr-10 outline-none font-bold text-sm text-gray-800 appearance-none border-2 border-transparent focus:border-blue-100 transition-all">
                   <option>Giáo xứ Đức Bà</option>
                   <option>Giáo xứ Tân Định</option>
                   <option>Giáo xứ Huyện Sỹ</option>
                </select>
                <ChevronDown className="absolute right-4 top-1/2 -translate-y-1/2 text-gray-300 w-5 h-5" />
             </div>

             <div className="bg-blue-50/50 rounded-2xl p-4 flex items-center gap-4 border border-blue-50">
                <div className="w-12 h-12 bg-white rounded-xl shadow-sm overflow-hidden border-2 border-white flex items-center justify-center">
                   <UserIcon className="w-7 h-7 text-blue-200" />
                </div>
                <div>
                   <p className="text-[10px] font-black text-blue-400 uppercase tracking-widest leading-none mb-1">Linh mục chánh xứ</p>
                   <p className="text-sm font-black text-blue-900">Lm. Gioan Baotixita Nguyễn Văn A</p>
                </div>
             </div>
          </section>

          {/* Section: Time Selection */}
          <section className="bg-white rounded-[28px] p-6 shadow-sm border border-gray-100">
             <div className="flex items-center gap-2 mb-4">
                <div className="w-8 h-8 rounded-xl bg-blue-50 flex items-center justify-center text-blue-600">
                   <Clock className="w-4 h-4" />
                </div>
                <h4 className="text-xs font-black text-gray-400 uppercase tracking-widest">Thời gian dự kiến</h4>
             </div>
             <div className="relative group">
                <input 
                   type="datetime-local" 
                   className="w-full bg-gray-50 rounded-2xl py-4 px-4 outline-none font-bold text-sm text-gray-800 border-2 border-transparent focus:border-blue-100 transition-all appearance-none"
                />
             </div>
          </section>

          {/* Section: Notes */}
          <section className="bg-white rounded-[28px] p-6 shadow-sm border border-gray-100">
             <div className="flex items-center gap-2 mb-4">
                <div className="w-8 h-8 rounded-xl bg-blue-50 flex items-center justify-center text-blue-600">
                   <Sparkles className="w-4 h-4" />
                </div>
                <h4 className="text-xs font-black text-gray-400 uppercase tracking-widest">Mục đích / Ghi chú</h4>
             </div>
             <textarea 
                placeholder="Nhập ý chỉ hoặc ghi chú thêm cho Cha xứ..."
                className="w-full bg-gray-50 rounded-2xl p-4 outline-none font-bold text-sm text-gray-800 min-h-[120px] border-2 border-transparent focus:border-blue-100 placeholder:text-gray-300 transition-all resize-none"
             />
          </section>

          {/* Submit Button */}
          <button className="w-full bg-blue-600 text-white py-5 rounded-[24px] font-black text-base shadow-xl shadow-blue-200 active:scale-[0.98] transition-all flex items-center justify-center gap-3">
             Gửi yêu cầu
             <ArrowRight className="w-5 h-5" />
          </button>
          
          <p className="text-center text-[10px] font-bold text-gray-400 px-8 leading-relaxed">
             Yêu cầu của bạn sẽ được gửi trực tiếp đến văn phòng giáo xứ. Bạn sẽ nhận được thông báo khi có phản hồi.
          </p>
       </div>
    </div>
  );
};

const ProfileScreen = ({ onBack, isAdminView = false, onMassRequestClick }: { onBack: () => void, isAdminView?: boolean, onMassRequestClick?: () => void }) => {
  return (
    <div className="flex flex-col min-h-full bg-[#F0F4F8] pb-32">
       {/* Header */}
       <header className="flex justify-between items-center px-4 py-3 sticky top-0 z-50 bg-white/95 backdrop-blur-sm border-b border-gray-100">
          <div className="flex items-center gap-2">
             <button onClick={onBack} className="p-2 text-blue-600">
                <ArrowLeft className="w-6 h-6" />
             </button>
             <div className="flex items-center gap-2">
                <AppLogo className="w-7 h-7 !rounded-lg" iconClassName="w-4 h-4" />
                <h1 className="text-sm font-display font-black text-primary uppercase tracking-wider">Thông tin Linh mục</h1>
             </div>
          </div>
          <button className="px-4 py-1.5 border border-blue-200 rounded-full text-blue-600 text-xs font-bold hover:bg-blue-50 transition-colors">
             Đăng xuất
          </button>
       </header>

       {/* Profile Hero */}
       <div className="flex flex-col items-center pt-6 pb-4">
          <div className="relative mb-4">
             <div className="w-36 h-36 rounded-full border-[6px] border-white shadow-2xl overflow-hidden ring-1 ring-gray-100">
                <img src="https://lh3.googleusercontent.com/aida-public/AB6AXuAGmWxIVRZHVY7sZx9oNTNW9sV-enLy9YHyVPr-YRyTC4Vh6W_vmM2iDr1MD-CjemRbQACN9AAJ89iVpX3iHMBpP4GGL3a6piruosdhoQUUHTRPhlVWaKVNaHF8ANPbA9YUry1cGQS_jKFqI0UTjdy6_aYS5HyPXG40xuBs3O4il6AEKAGcxaeqzev1PRXYCDlSbDyswI3Z2mXxUwu9plX7-SPrJX-fD6vVa4QTxtxUNwB7i5sXy9uVOcmOvi_nqNb7-epUpvMR-K65" className="w-full h-full object-cover" />
             </div>
             <div className="absolute bottom-1.5 right-1.5 bg-blue-600 p-1.5 rounded-full border-[3px] border-white shadow-lg">
                <Verified className="w-4 h-4 text-white" />
             </div>
          </div>
          <div className="text-center">
             <p className="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mb-1">TÊN THÁNH</p>
             <h2 className="text-2xl font-display font-black text-gray-900 leading-none mb-1">{isAdminView ? 'Phaolô' : 'Giuse'}</h2>
             <h2 className="text-2xl font-display font-black text-blue-600 leading-none">{isAdminView ? 'Hoàng Mạnh Huy' : 'Nguyễn Văn A'}</h2>
             <div className="mt-3 bg-[#E6F7F0] text-[#1DB171] px-4 py-1.5 rounded-full text-[10px] font-black uppercase tracking-widest border border-[#C6EFDE] inline-flex items-center gap-1.5">
                <span className="w-2 h-2 bg-[#1DB171] rounded-full" />
                Đang hoạt động
             </div>
          </div>
       </div>

       {/* Digital ID Card */}
       <div className="px-4 mb-6">
          <div className="bg-gradient-to-br from-[#1976D2] to-[#1565C0] rounded-2xl p-6 shadow-[0_12px_24px_rgba(25,118,210,0.25)] text-white relative overflow-hidden h-[180px]">
             {/* Architectural Graphic */}
             <div className="absolute right-0 bottom-0 top-6 w-full opacity-[0.08] pointer-events-none">
                <Church className="w-64 h-64 -mr-16 -mb-16 float-right" />
             </div>
             
             <div className="relative z-10 flex flex-col justify-between h-full">
                <div className="flex justify-between items-start">
                   <div className="space-y-1">
                      <p className="text-[10px] font-black opacity-60 tracking-widest uppercase">MÃ ĐỊNH DANH</p>
                      <h3 className="text-3xl font-black font-mono tracking-widest">ECC-882-021</h3>
                   </div>
                   <div className="w-7 h-7 border border-white/30 rounded-lg flex items-center justify-center">
                      <div className="w-3.5 h-3.5 border border-white/50" />
                   </div>
                </div>
                
                <div className="flex justify-between items-end">
                   <div className="space-y-1">
                      <p className="text-[10px] font-black opacity-60 tracking-widest uppercase">GIÁO PHẬN</p>
                      <p className="text-lg font-black leading-tight">{isAdminView ? 'Giáo phận Phú Cường' : 'Tổng Giáo Phận Sài Gòn'}</p>
                   </div>
                   <div className="w-14 h-14 bg-white/20 backdrop-blur-md rounded-xl flex items-center justify-center border border-white/30 shadow-lg group">
                      <QrCode className="w-8 h-8 text-white group-active:scale-110 transition-transform" />
                   </div>
                </div>
             </div>
          </div>
       </div>

       {/* Details Grid */}
       <div className="px-4 mt-2 space-y-4">
          <div className="flex items-center gap-2 px-1">
             <InfoIcon className="w-4 h-4 text-gray-400" />
             <h4 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">THÔNG TIN CHI TIẾT</h4>
          </div>

          <div className="grid grid-cols-2 gap-4">
             <div className="bg-white p-5 rounded-3xl shadow-sm border border-gray-50 flex flex-col items-start gap-4">
                <div className="w-10 h-10 rounded-2xl bg-[#E3F2FD] flex items-center justify-center text-[#2196F3]">
                   <Calendar className="w-6 h-6" />
                </div>
                <div>
                   <p className="text-[11px] text-gray-400 font-bold tracking-wide">Ngày sinh</p>
                   <p className="text-lg font-black text-gray-800">{isAdminView ? '12/05/1980' : '15/03/1975'}</p>
                </div>
             </div>
             <div className="bg-white p-5 rounded-3xl shadow-sm border border-gray-50 flex flex-col items-start gap-4">
                <div className="w-10 h-10 rounded-2xl bg-[#E3F2FD] flex items-center justify-center text-[#2196F3]">
                   <Sparkles className="w-6 h-6" />
                </div>
                <div>
                   <p className="text-[11px] text-gray-400 font-bold tracking-wide">Thụ phong</p>
                   <p className="text-lg font-black text-gray-800">{isAdminView ? '20/06/2008' : '24/06/2002'}</p>
                </div>
             </div>
          </div>

          <div className="bg-white rounded-3xl shadow-sm border border-gray-50 overflow-hidden">
             {[
               { icon: MapPin, label: 'Giáo xứ hiện tại', value: isAdminView ? 'Giáo xứ Phú Cường' : 'Giáo xứ Tân Định' },
               { icon: GraduationCap, label: 'Học hàm/Học vị', value: isAdminView ? 'Thạc sĩ Mục vụ' : 'Tiến sĩ Thần học' },
               { icon: UserIcon, label: 'Ngày rửa tôi', value: isAdminView ? '12/05/1980' : '25/03/1975' },
               { icon: ShieldCheck, label: 'Ngày thêm sức', value: isAdminView ? '15/05/1992' : '15/05/1987' },
               { icon: School, label: 'Vào Tiểu chủng viện', value: isAdminView ? '05/09/1995' : '05/09/1990' },
               { icon: Building, label: 'Vào Đại chủng viện', value: isAdminView ? '01/09/2001' : '01/09/1996' },
               { icon: Sparkles, label: 'Truyền chức Phó tế', value: isAdminView ? '31/05/2007' : '31/05/2001' },
               { icon: Mail, label: 'Email liên hệ', value: isAdminView ? 'hoangmanhhuy@gmail.com' : 'giuse.ngvan@ecclesia.vn', blue: true }
             ].map((item, idx) => (
                <div key={idx} className="p-4 flex items-center justify-between border-b last:border-0 border-gray-50">
                   <div className="flex items-center gap-3">
                      <item.icon className="w-4 h-4 text-gray-400" />
                      <span className="text-[11px] font-bold text-gray-400 uppercase tracking-tight">{item.label}</span>
                   </div>
                   <span className={`text-[13px] font-black ${item.blue ? 'text-blue-600 underline' : 'text-gray-800'}`}>{item.value}</span>
                </div>
             ))}
          </div>

          {/* Redesigned QR Display Section (More compact/Modern) */}
          <div className="bg-[#f0f9ff] rounded-3xl p-5 border border-blue-100 shadow-sm flex items-center gap-6">
             <div className="relative flex-shrink-0 w-28 h-28 bg-white p-3 rounded-2xl border border-blue-50 flex items-center justify-center group overflow-hidden">
                <div className="absolute inset-0 bg-gradient-to-br from-blue-50/50 to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
                {/* Modern subtle corners */}
                <div className="absolute top-2 left-2 w-3 h-3 border-t-2 border-l-2 border-primary/20 rounded-tl-md" />
                <div className="absolute bottom-2 right-2 w-3 h-3 border-b-2 border-r-2 border-primary/20 rounded-br-md" />
                
                <div className="relative w-full h-full p-0.5 opacity-90 transition-transform group-hover:scale-110">
                   <QrCode className="w-full h-full text-blue-950" strokeWidth={1} />
                </div>
             </div>
             
             <div className="flex-1 text-left space-y-1.5">
                <h3 className="text-lg font-display font-black text-blue-600 leading-tight">Mã QR định danh</h3>
                <p className="text-[10px] font-bold text-gray-400 leading-relaxed">
                   Quét mã để xác thực quyền hành lễ hoặc điểm danh sự kiện giáo phận.
                </p>
                <div className="flex items-center gap-2 mt-2">
                   <div className="px-2.5 py-0.5 bg-blue-100/50 rounded-full text-[9px] font-black text-blue-600 uppercase tracking-widest border border-blue-100">
                      Đã mã hóa
                   </div>
                   <div className="px-2.5 py-0.5 bg-emerald-100/50 rounded-full text-[9px] font-black text-emerald-600 uppercase tracking-widest border border-emerald-100">
                      Hợp lệ
                   </div>
                </div>
             </div>
          </div>

          {/* Timeline Section */}
          <section className="space-y-3">
             <div className="flex items-center gap-2 px-1">
                <History className="w-4 h-4 text-gray-500" />
                <h4 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">HOẠT ĐỘNG SỨ VỤ</h4>
             </div>
             <div className="bg-white rounded-3xl p-6 shadow-sm border border-gray-50">
                <div className="space-y-8 relative">
                   <div className="absolute left-[7px] top-2 bottom-6 w-[2px] bg-gray-100/50" />
                   
                   <div className="relative pl-8">
                      <div className="absolute left-0 top-1.5 w-4 h-4 rounded-full bg-blue-600 ring-4 ring-blue-100" />
                      <div className="flex flex-col gap-1">
                         <span className="text-[11px] font-black text-blue-600 uppercase tracking-widest">2022 - NAY</span>
                         <h5 className="text-base font-black text-gray-800 uppercase leading-snug">Trưởng ban Truyền thông</h5>
                         <p className="text-xs font-bold text-gray-400">Giáo phận Phú Cường</p>
                      </div>
                   </div>

                   <div className="relative pl-8">
                      <div className="absolute left-0 top-1.5 w-4 h-4 rounded-full bg-gray-200 border-2 border-white ring-4 ring-white" />
                      <div className="flex flex-col gap-1">
                         <span className="text-[11px] font-black text-gray-400 uppercase tracking-widest">2018 - 2022</span>
                         <h5 className="text-base font-black text-gray-700 uppercase leading-snug">Phó ban Truyền thông</h5>
                         <p className="text-xs font-bold text-gray-400">Ban Truyền thông Giáo phận</p>
                      </div>
                   </div>

                   <div className="relative pl-8">
                      <div className="absolute left-0 top-1.5 w-4 h-4 rounded-full bg-gray-200 border-2 border-white ring-4 ring-white" />
                      <div className="flex flex-col gap-1">
                         <span className="text-[11px] font-black text-gray-400 uppercase tracking-widest">{isAdminView ? '2016 - 2018' : '2018 - Nay'}</span>
                         <h5 className="text-base font-black text-gray-700 uppercase leading-snug">{isAdminView ? 'Chánh xứ' : 'Chánh xứ'}</h5>
                         <p className="text-xs font-bold text-gray-400">{isAdminView ? 'Giáo xứ Phú Cường, Thủ Dầu Một' : 'Giáo xứ Tân Định, Quận 3, TP.HCM'}</p>
                      </div>
                   </div>

                   <div className="relative pl-8">
                      <div className="absolute left-0 top-1.5 w-4 h-4 rounded-full bg-gray-200 border-2 border-white ring-4 ring-white" />
                      <div className="flex flex-col gap-1">
                         <span className="text-[11px] font-black text-gray-400 uppercase tracking-widest">{isAdminView ? '2010 - 2016' : '2012 - 2018'}</span>
                         <h5 className="text-base font-black text-gray-700 uppercase leading-snug">{isAdminView ? 'Phó xứ' : 'Phụ tá Giám đốc'}</h5>
                         <p className="text-xs font-bold text-gray-400">{isAdminView ? 'Giáo xứ Chánh Tòa Phú Cường' : 'Đại chủng viện Thánh Giuse Sài Gòn'}</p>
                      </div>
                   </div>
                </div>
             </div>
          </section>

          {/* Update List */}
          <section className="space-y-4">
             <h4 className="text-[10px] font-black text-gray-400 uppercase tracking-widest px-1">LỊCH SỬ CẬP NHẬT</h4>
             <div className="bg-white rounded-3xl p-6 shadow-sm border border-gray-50 divide-y divide-gray-50">
                <div className="py-3 flex justify-between items-center group">
                   <div className="flex items-center gap-3">
                      <div className="w-2 h-2 rounded-full bg-gray-200" />
                      <span className="text-xs font-bold text-gray-600">Cập nhật chức vụ mới</span>
                   </div>
                   <span className="text-xs font-black text-gray-300">12/10/2023</span>
                </div>
                <div className="py-3 flex justify-between items-center group">
                   <div className="flex items-center gap-3">
                      <div className="w-2 h-2 rounded-full bg-gray-200" />
                      <span className="text-xs font-bold text-gray-600">Thay đổi địa chỉ liên lạc</span>
                   </div>
                   <span className="text-xs font-black text-gray-300">05/08/2023</span>
                </div>
             </div>
          </section>
       </div>
    </div>
  );
};

const ScanScreen = ({ onClose }: { onClose: () => void }) => {
  return (
    <div className="absolute inset-0 bg-white z-[60] flex flex-col h-full overflow-hidden">
       {/* High-end Header */}
       <header className="flex items-center px-4 py-3 bg-white/80 backdrop-blur-md sticky top-0 z-50 border-b border-gray-100/50">
          <button onClick={onClose} className="p-2 text-primary hover:bg-primary/5 rounded-full active:scale-95 transition-all">
             <ArrowLeft className="w-6 h-6" />
          </button>
          <div className="flex-1 text-center pr-10">
             <h1 className="text-xl font-display font-black text-gray-800 tracking-tight">Quét mã QR</h1>
          </div>
       </header>

       <div className="flex-1 relative flex flex-col items-center justify-center p-6 bg-slate-900">
          {/* Simulated Camera View with realistic texture */}
          <div className="absolute inset-0 w-full h-full overflow-hidden">
            <img 
              src="https://images.unsplash.com/photo-1550751827-4bd374c3f58b?auto=format&fit=crop&q=80&w=2070" 
              className="w-full h-full object-cover scale-110 opacity-40 mix-blend-overlay grayscale" 
            />
            <div className="absolute inset-0 bg-gradient-to-b from-slate-900/60 via-transparent to-slate-900/80" />
            
            {/* Added dynamic light leak effect for "brightness" */}
            <div className="absolute -top-40 -right-40 w-80 h-80 bg-primary/20 blur-[100px] rounded-full" />
            <div className="absolute -bottom-40 -left-40 w-80 h-80 bg-blue-400/10 blur-[100px] rounded-full" />
          </div>
          
          {/* Main Scanner Window */}
          <div className="relative group">
             {/* Scanning glow effect around the box */}
             <div className="absolute -inset-8 bg-primary/10 blur-[50px] opacity-0 group-hover:opacity-100 transition-opacity duration-1000" />
             
             <div className="relative w-64 h-64 md:w-80 md:h-80 z-10 transition-transform group-hover:scale-[1.02] duration-500">
                {/* Corner Accents - Premium Version with more rounded corners */}
                <div className="absolute -top-2 -left-2 w-16 h-16 border-t-[6px] border-l-[6px] border-primary rounded-tl-[36px] shadow-[0_0_20px_rgba(37,99,235,0.6)]" />
                <div className="absolute -top-2 -right-2 w-16 h-16 border-t-[6px] border-r-[6px] border-primary rounded-tr-[36px] shadow-[0_0_20px_rgba(37,99,235,0.6)]" />
                <div className="absolute -bottom-2 -left-2 w-16 h-16 border-b-[6px] border-l-[6px] border-primary rounded-bl-[36px] shadow-[0_0_20px_rgba(37,99,235,0.6)]" />
                <div className="absolute -bottom-2 -right-2 w-16 h-16 border-b-[6px] border-r-[6px] border-primary rounded-br-[36px] shadow-[0_0_20px_rgba(37,99,235,0.6)]" />
                
                {/* Internal Scan Area - Glass overlay feel */}
                <div className="absolute inset-0 bg-white/5 backdrop-blur-[2px] border border-white/20 rounded-[30px] overflow-hidden">
                   {/* Scanning Line - High velocity modern feel */}
                   <motion.div 
                     animate={{ top: ['0%', '100%', '0%'] }} 
                     transition={{ duration: 3, repeat: Infinity, ease: "linear" }}
                     className="absolute left-0 right-0 h-[4px] bg-gradient-to-r from-transparent via-primary to-transparent z-20 shadow-[0_0_25px_rgba(37,99,235,1)]"
                   />
                   
                   {/* Scan overlay grid */}
                   <div className="absolute inset-0 opacity-[0.1] pointer-events-none" 
                        style={{ backgroundImage: 'radial-gradient(circle, #2563eb 1px, transparent 1px)', backgroundSize: '24px 24px' }} />
                </div>
             </div>
          </div>
          
          {/* Instructions with premium label styling */}
          <div className="mt-16 relative z-20 flex flex-col items-center gap-6">
             <div className="px-10 py-3.5 bg-white/10 backdrop-blur-2xl rounded-full border border-white/20 shadow-2xl flex items-center gap-3">
                <span className="relative flex h-3 w-3">
                   <span className="animate-ping absolute inline-flex h-full w-full rounded-full bg-primary opacity-75"></span>
                   <span className="relative inline-flex rounded-full h-3 w-3 bg-primary"></span>
                </span>
                <p className="text-[15px] font-black text-white tracking-wide uppercase">
                   Đang quét mã QR
                </p>
             </div>
             
             <div className="bg-black/20 backdrop-blur-md px-6 py-2 rounded-2xl border border-white/5">
                <p className="text-white/60 text-xs font-bold text-center italic tracking-wider">
                   Căn chỉnh mã vào trong khung để nhận diện
                </p>
             </div>
          </div>
          
          {/* Interactive Controls - Floating glass clusters */}
          <div className="absolute bottom-12 flex items-center gap-10 z-30">
             <button className="group flex flex-col items-center gap-3 active:scale-90 transition-all">
                <div className="w-16 h-16 bg-white/10 hover:bg-white/20 backdrop-blur-3xl rounded-full flex items-center justify-center text-white border border-white/20 shadow-2xl transition-all duration-300">
                   <Flashlight className="w-7 h-7 group-hover:text-primary transition-colors" />
                </div>
                <span className="text-[10px] font-black text-white/40 uppercase tracking-widest">Đèn pin</span>
             </button>
             
             <button className="group flex flex-col items-center gap-3 active:scale-90 transition-all">
                <div className="w-16 h-16 bg-white/10 hover:bg-white/20 backdrop-blur-3xl rounded-full flex items-center justify-center text-white border border-white/20 shadow-2xl transition-all duration-300">
                   <ImageIcon className="w-7 h-7 group-hover:text-primary transition-colors" />
                </div>
                <span className="text-[10px] font-black text-white/40 uppercase tracking-widest">Tải ảnh lên</span>
             </button>
          </div>
       </div>

       {/* Safe area floor - ensures it feels connected to the bottom nav but integrated */}
       <div className="h-16 bg-slate-900 border-t border-white/5 flex items-center justify-center px-6 shrink-0">
          <div className="w-24 h-1.5 bg-white/10 rounded-full" />
       </div>
    </div>
  );
};

const NFCScreen = ({ onCancel }: { onCancel: () => void }) => {
  return (
    <div className="absolute inset-0 bg-white z-[60] flex flex-col h-full overflow-hidden items-center text-center">
       {/* Ambient Ripples - matched to image style precisely */}
       <div className="absolute inset-0 flex items-center justify-center -z-10 pointer-events-none">
          <div className="absolute w-[240px] h-[240px] rounded-full border border-blue-100/40"></div>
          <div className="absolute w-[380px] h-[380px] rounded-full border border-blue-100/40"></div>
          <div className="absolute w-[520px] h-[520px] rounded-full border border-blue-100/40"></div>
          <div className="absolute w-[660px] h-[660px] rounded-full border border-blue-50/30"></div>
          <div className="absolute w-[800px] h-[800px] rounded-full border border-blue-50/20"></div>
       </div>

       <div className="flex-grow flex flex-col items-center justify-center w-full max-w-md mx-auto">
          {/* Scanner Visual Container */}
          <div className="relative mb-12">
             {/* Big Light Circle */}
             <div className="w-52 h-52 bg-[#e9ebf2] rounded-full flex items-center justify-center shadow-lg shadow-gray-100/50">
                {/* Blue Inner Circle with Waves - Matched closer to image */}
                <div className="w-24 h-24 bg-[#004ac6] rounded-full flex items-center justify-center border-4 border-white shadow-xl">
                   <div className="rotate-0">
                      <Rss className="w-12 h-12 text-white rotate-[135deg]" strokeWidth={2.5} />
                   </div>
                </div>
             </div>
             
             {/* Floating Card Mockup - matched to image precisely */}
             <motion.div 
               initial={{ x: 20, y: 0, rotate: 12 }}
               animate={{ y: [0, -8, 0], rotate: [12, 10, 12] }}
               transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
               className="absolute bottom-2 -right-2 w-32 h-[84px] bg-gradient-to-br from-[#1b5ed8] to-[#04aedc] rounded-xl shadow-2xl flex items-center justify-center border border-white/20"
             >
                <div className="flex flex-col items-center gap-1.5">
                   <div className="w-10 h-10 bg-white/10 rounded-lg flex items-center justify-center backdrop-blur-sm border border-white/20">
                      <Contact className="w-7 h-7 text-white" />
                   </div>
                   <div className="w-12 h-0.5 bg-white/20 rounded-full" />
                </div>
             </motion.div>
          </div>

          {/* Instruction Text - matched typography */}
          <div className="space-y-4 px-6">
             <h2 className="text-[28px] font-display font-black text-[#1a1c24] tracking-tight">Đang quét NFC</h2>
             <p className="text-base font-bold text-gray-400 max-w-[300px] mx-auto leading-relaxed">
                Vui lòng chạm thẻ linh mục vào vùng cảm biến NFC trên điện thoại
             </p>
          </div>
       </div>

       {/* Bottom Action - matched to image outlined style */}
       <div className="w-full px-6 pb-12">
          <button 
            onClick={onCancel}
            className="w-full h-16 flex items-center justify-center rounded-xl border-2 border-[#d9dae5] text-[#444654] font-black text-sm active:bg-gray-50 transition-all gap-2"
          >
             <X className="w-5 h-5" strokeWidth={3} />
             Hủy
          </button>
       </div>
    </div>
  );
};

// --- App Entry Point ---

export default function App() {
  const [activeTab, setActiveTab] = useState('home');
  const [currentScreen, setCurrentScreen] = useState<'home' | 'profile' | 'scan' | 'nfc' | 'login' | 'priest-dashboard' | 'priest-profile' | 'mass-request' | 'mass-request-detail' | 'history' | 'settings' | 'search-detail' | 'notifications' | 'priest-help' | 'my-qr'>('home');
  const [userRole, setUserRole] = useState<'public' | 'priest'>('public');
  const [isBiometricModalOpen, setIsBiometricModalOpen] = useState(false);
  const [selectedBiometric, setSelectedBiometric] = useState<'faceid' | 'fingerprint' | null>(null);

  const renderScreen = () => {
    switch (currentScreen) {
      case 'home': return (
        <LaymanHomeScreen 
          onPriestClick={() => setCurrentScreen('profile')} 
          onLoginClick={() => setCurrentScreen('login')} 
        />
      );
      case 'profile': return <ProfileScreen onBack={() => handleTabChange('home')} />;
      case 'priest-profile': return <ProfileScreen onBack={() => setCurrentScreen('priest-dashboard')} isAdminView={true} />;
      case 'scan': return <ScanScreen onClose={() => handleTabChange('home')} />;
      case 'nfc': return <NFCScreen onCancel={() => handleTabChange('home')} />;
      case 'mass-request': return <MassRequestScreen onBack={() => setCurrentScreen(userRole === 'priest' ? 'priest-dashboard' : 'profile')} />;
      case 'mass-request-detail': return <MassRequestDetailScreen onBack={() => setCurrentScreen('priest-dashboard')} />;
      case 'history': return <HistoryScreen />;
      case 'settings': return <SettingsScreen onBellClick={() => setCurrentScreen('notifications')} />;
      case 'search-detail': return <SearchDetailScreen onBack={() => setCurrentScreen('priest-dashboard')} />;
      case 'notifications': return <NotificationsScreen onBack={() => setCurrentScreen(userRole === 'priest' ? 'priest-dashboard' : 'settings')} />;
      case 'priest-help': return <PriestHelpScreen onBack={() => setCurrentScreen('priest-dashboard')} />;
      case 'my-qr': return <MyQrScreen onBack={() => setCurrentScreen('priest-dashboard')} />;
      case 'login': return (
        <LoginScreen 
          onLogin={() => { setUserRole('priest'); setCurrentScreen('priest-dashboard'); setActiveTab('home'); }} 
          onBack={() => setCurrentScreen('home')} 
        />
      );
      case 'priest-dashboard': return (
        <PriestHomeScreen 
          onLogout={() => { setUserRole('public'); setCurrentScreen('home'); setActiveTab('home'); }} 
          onProfileClick={() => setCurrentScreen('priest-profile')}
          onBiometricClick={() => setIsBiometricModalOpen(true)}
          onMassRequestClick={() => setCurrentScreen('mass-request')}
          onNfcClick={() => setCurrentScreen('nfc')}
          onNotificationClick={() => setCurrentScreen('mass-request-detail')}
          onMyQrClick={() => setCurrentScreen('my-qr')}
          onSearchClick={() => setCurrentScreen('search-detail')}
          onBellClick={() => setCurrentScreen('notifications')}
          onHelpClick={() => setCurrentScreen('priest-help')}
        />
      );
      default: return <LaymanHomeScreen onPriestClick={() => setCurrentScreen('profile')} onLoginClick={() => setCurrentScreen('login')} />;
    }
  };

  const handleTabChange = (tab: string) => {
    setActiveTab(tab);
    if (tab === 'home') setCurrentScreen(userRole === 'priest' ? 'priest-dashboard' : 'home');
    if (tab === 'scan') setCurrentScreen('scan');
    if (tab === 'nfc') setCurrentScreen('nfc');
    if (tab === 'history') setCurrentScreen('history');
    if (tab === 'settings') setCurrentScreen('settings');
  };

  return (
    <div className="bg-gray-200 min-h-screen flex items-center justify-center sm:p-4">
      <div className="w-full max-w-[440px] bg-white h-[100dvh] sm:h-[880px] sm:rounded-[60px] relative overflow-hidden shadow-[0_32px_64px_rgba(0,0,0,0.2)] border-x sm:border-y border-gray-200/50">
        <div className="absolute inset-0 overflow-y-auto no-scrollbar scroll-smooth">
          <AnimatePresence mode="wait">
            <motion.div
               key={currentScreen}
               initial={{ opacity: 0, scale: 0.98 }}
               animate={{ opacity: 1, scale: 1 }}
               exit={{ opacity: 0, scale: 1.02 }}
               transition={{ duration: 0.4, ease: [0.22, 1, 0.36, 1] }}
            >
              {renderScreen()}
            </motion.div>
          </AnimatePresence>
        </div>

        <AnimatePresence>
          {isBiometricModalOpen && (
            <div className="absolute inset-0 z-[100] flex items-end justify-center bg-black/40 backdrop-blur-sm">
              <motion.div
                initial={{ y: "100%" }}
                animate={{ y: 0 }}
                exit={{ y: "100%" }}
                transition={{ type: "spring", damping: 25, stiffness: 200 }}
                className="w-full bg-white rounded-t-[40px] p-6 pb-12 shadow-2xl relative"
              >
                <div className="w-12 h-1.5 bg-gray-200 rounded-full mx-auto mb-8" />
                
                <div className="text-center mb-8">
                  <div className="w-20 h-20 bg-emerald-50 rounded-full flex items-center justify-center mx-auto mb-4 border-2 border-emerald-100 shadow-sm">
                    <Fingerprint className="w-10 h-10 text-emerald-600" />
                  </div>
                  <h3 className="text-2xl font-display font-black text-gray-800">Bảo mật sinh trắc học</h3>
                  <p className="text-sm text-gray-400 font-bold mt-1">Chọn phương thức mở khoá phù hợp</p>
                </div>

                <div className="grid grid-cols-2 gap-4">
                  <button 
                    onClick={() => { setSelectedBiometric('faceid'); setIsBiometricModalOpen(false); }}
                    className={`flex flex-col items-center justify-center p-6 rounded-[32px] border-2 transition-all active:scale-95 ${
                      selectedBiometric === 'faceid' ? 'border-blue-600 bg-blue-50/50' : 'border-gray-50 bg-gray-50'
                    }`}
                  >
                    <div className="w-14 h-14 bg-white rounded-2xl flex items-center justify-center shadow-sm mb-3">
                      <Smartphone className="w-7 h-7 text-blue-600" />
                    </div>
                    <span className="text-sm font-black text-gray-700">FaceID</span>
                    {selectedBiometric === 'faceid' && <CheckCircle2 className="w-4 h-4 text-blue-600 mt-2" />}
                  </button>

                  <button 
                    onClick={() => { setSelectedBiometric('fingerprint'); setIsBiometricModalOpen(false); }}
                    className={`flex flex-col items-center justify-center p-6 rounded-[32px] border-2 transition-all active:scale-95 ${
                      selectedBiometric === 'fingerprint' ? 'border-primary bg-primary/5' : 'border-gray-50 bg-gray-50'
                    }`}
                  >
                    <div className="w-14 h-14 bg-white rounded-2xl flex items-center justify-center shadow-sm mb-3">
                      <Fingerprint className="w-7 h-7 text-primary" />
                    </div>
                    <span className="text-sm font-black text-gray-700">Vân tay</span>
                    {selectedBiometric === 'fingerprint' && <CheckCircle2 className="w-4 h-4 text-primary mt-2" />}
                  </button>
                </div>

                <button 
                  onClick={() => setIsBiometricModalOpen(false)}
                  className="w-full mt-8 py-4 text-gray-400 font-black text-sm uppercase tracking-widest"
                >
                  Bỏ qua
                </button>
              </motion.div>
            </div>
          )}
        </AnimatePresence>
        
        {currentScreen !== 'scan' && currentScreen !== 'nfc' && currentScreen !== 'login' && (
          <BottomNav activeTab={activeTab} onTabChange={handleTabChange} />
        )}
      </div>
    </div>
  );
}
