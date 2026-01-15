<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" tagdir="/WEB-INF/tags/ui" %>
<%@tag description="Main Layout" pageEncoding="UTF-8" import="common.constant.RoleConstant"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>JLPTHub</title>
        <script src="/js/tailwindcss.js"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <style type="text/tailwindcss">
            @theme inline {
                --radius-sm: calc(var(--radius) - 4px);
                --radius-md: calc(var(--radius) - 2px);
                --radius-lg: var(--radius);
                --radius-xl: calc(var(--radius) + 4px);
                --color-background: var(--background);
                --color-foreground: var(--foreground);
                --color-card: var(--card);
                --color-card-foreground: var(--card-foreground);
                --color-popover: var(--popover);
                --color-popover-foreground: var(--popover-foreground);
                --color-primary: var(--primary);
                --color-primary-foreground: var(--primary-foreground);
                --color-secondary: var(--secondary);
                --color-secondary-foreground: var(--secondary-foreground);
                --color-muted: var(--muted);
                --color-muted-foreground: var(--muted-foreground);
                --color-accent: var(--accent);
                --color-accent-foreground: var(--accent-foreground);
                --color-destructive: var(--destructive);
                --color-border: var(--border);
                --color-input: var(--input);
                --color-ring: var(--ring);
                --color-chart-1: var(--chart-1);
                --color-chart-2: var(--chart-2);
                --color-chart-3: var(--chart-3);
                --color-chart-4: var(--chart-4);
                --color-chart-5: var(--chart-5);
            }

            :root {
                --default-font-family: 'Tiktok Text';
                --radius: 0.625rem;
                --background: oklch(1 0 0);
                --foreground: oklch(0.14 0.05 13.428);
                --card: oklch(1 0 0);
                --card-foreground: oklch(0.14 0.05 13.428);
                --popover: oklch(1 0 0);
                --popover-foreground: oklch(0.14 0.05 13.428);
                --primary: oklch(0.712 0.194 13.428);
                --primary-foreground: oklch(1 0 0);
                --secondary: oklch(0.94 0.04 13.428);
                --secondary-foreground: oklch(0.25 0.08 13.428);
                --muted: oklch(0.96 0.01 13.428);
                --muted-foreground: oklch(0.55 0.05 13.428);
                --accent: oklch(0.92 0.06 13.428);
                --accent-foreground: oklch(0.25 0.08 13.428);
                --destructive: oklch(0.6 0.25 25);
                --destructive-foreground: oklch(0.98 0 0);
                --border: oklch(0.92 0.02 13.428);
                --input: oklch(0.92 0.02 13.428);
                --ring: oklch(0.712 0.194 13.428);
                --chart-1: oklch(0.712 0.194 13.428);
                --chart-2: oklch(0.68 0.16 45);
                --chart-3: oklch(0.65 0.14 340);
                --chart-4: oklch(0.75 0.15 85);
                --chart-5: oklch(0.70 0.12 180);
            }

            dialog::backdrop {
                background: rgba(0, 0, 0, 0.8);
                animation: fade-in 0.2s ease-out;
            }

            dialog[open] {
                animation: zoom-in 0.2s ease-out;
            }

            @keyframes fade-in {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }
            @keyframes zoom-in {
                from {
                    opacity: 0;
                    transform: scale(0.96);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }
            @keyframes dropdown {
                from {
                    opacity: 0;
                    transform: scale(0.95) translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: scale(1) translateY(0);
                }
            }
            .animate-in {
                animation: dropdown 0.1s ease-out forwards;
            }
            .scrollbar-hide {
                scrollbar-width: none;
            }

            /* Flip Card Animation */
            .flip-card {
                perspective: 1000px;
                height: 320px;
            }
            .flip-card-inner {
                position: relative;
                width: 100%;
                height: 100%;
                transition: transform 0.6s;
                transform-style: preserve-3d;
            }
            .flip-card.flipped .flip-card-inner {
                transform: rotateY(180deg);
            }
            .flip-card-front, .flip-card-back {
                position: absolute;
                width: 100%;
                height: 100%;
                backface-visibility: hidden;
                -webkit-backface-visibility: hidden;
            }
            .flip-card-back {
                transform: rotateY(180deg);
            }
        </style>
        <script>
            // Open a dialog by ID
            function openDialog (id) {
                const dialog = document.getElementById(id);
                if (dialog) {
                    dialog.showModal();
                    document.body.style.overflow = 'hidden'; // Prevent background scrolling
                }
            }

            // Close a dialog by ID (or 'this')
            function closeDialog (element) {
                const dialog = element.closest('dialog');
                if (dialog) {
                    dialog.close();
                    document.body.style.overflow = ''; // Restore scrolling
                }
            }

            function validateInput (id, validationCallback) {
                const inputEl = document.getElementById(id);
                const errorEl = document.getElementById('error-' + id);

                const errorMessage = validationCallback(inputEl.value);

                if (errorMessage) {
                    inputEl.classList.add('border-red-500');
                    errorEl.classList.remove("hidden");
                    errorEl.innerText = errorMessage;
                    return false;
                } else {
                    inputEl.classList.remove('border-red-500');
                    errorEl.classList.add("hidden");
                    errorEl.innerText = "";
                    return true;
                }
            }

            function submitForm (id) {
                document.getElementById(id).submit();
            }

            function toggleSelect (triggerId) {
                const content = document.getElementById(triggerId + '-content');
                const trigger = document.getElementById(triggerId + "-trigger");

                const isHidden = content.classList.contains('hidden');

                document.querySelectorAll('[id$="-content"]').forEach(el => el.classList.add('hidden'));

                if (isHidden) {
                    content.classList.remove('hidden');
                    trigger.setAttribute('aria-expanded', 'true');
                } else {
                    content.classList.add('hidden');
                    trigger.setAttribute('aria-expanded', 'false');
                }
            }

            function selectOption (triggerId, value, label) {
                const input = document.getElementById(triggerId);
                input.value = value;

                const display = document.getElementById(triggerId + '-value');
                display.innerText = label;

                const content = document.getElementById(triggerId + '-content');
                content.classList.add('hidden');

                const trigger = document.getElementById(triggerId + "-trigger");
                trigger.setAttribute('aria-expanded', 'false');
            }

            document.addEventListener('click', function (event) {
                if (event.target.tagName === 'DIALOG') {
                    const rect = event.target.getBoundingClientRect();
                    const isInDialog = (rect.top <= event.clientY && event.clientY <= rect.top + rect.height
                            && rect.left <= event.clientX && event.clientX <= rect.left + rect.width);

                    if (!isInDialog) {
                        event.target.close();
                        document.body.style.overflow = '';
                    }
                }

                if (!event.target.closest('.custom-select-container')) {
                    document.querySelectorAll('[id$="-content"]').forEach(el => el.classList.add('hidden'));
                    document.querySelectorAll('[aria-expanded="true"]').forEach(el => el.setAttribute('aria-expanded', 'false'));
                }
            });

            function scrollCarousel (id, next) {
                const container = document.getElementById(id);
                if (container) {
                    const scrollAmount = container.clientWidth;
                    container.scrollBy({
                        left: next ? scrollAmount : -scrollAmount,
                        behavior: 'smooth'
                    });
                }
            }

            function flipCard (id) {
                const card = document.getElementById(id);
                if (card) {
                    card.classList.toggle('flipped');
                }
            }

            function getCookie (name) {
                const nameEQ = name + "=";
                const ca = document.cookie.split(';');
                for (let i = 0; i < ca.length; i++) {
                    let c = ca[i];
                    while (c.charAt(0) === ' ') {
                        c = c.substring(1);
                    }
                    if (c.indexOf(nameEQ) === 0) {
                        return c.substring(nameEQ.length, c.length);
                    }
                }
                return "";
            }

            let isSidebarExpanded = false;
            document.addEventListener("DOMContentLoaded", () => {
                const cookieValue = getCookie('isSidebarExpanded');
                console.log(cookieValue);
                if (cookieValue === "true") {
                    isSidebarExpanded = true;
                } else if (cookieValue === "false") {
                    isSidebarExpanded = false;
                } else {
                    toggleSidebar();
                }
                updateSidebarUI();
            });

            function toggleSidebar () {
                isSidebarExpanded = !isSidebarExpanded;
                document.cookie = "isSidebarExpanded=" + isSidebarExpanded;
                updateSidebarUI();
            }

            function updateSidebarUI () {
                const sidebarLogo = document.getElementById("sidebar-logo");
                const sidebarSection = document.getElementById("sidebar-section");
                const sidebarItems = document.querySelectorAll(".sidebar-item");
                const sidebarUserInfo = document.getElementById("sidebar-user-info");
                const sidebarButton = document.querySelector(".sidebar-button");
                const sidebarExpanded = document.getElementById("sidebar-expanded");
                const sidebarCollapsed = document.getElementById("sidebar-collapsed");
                const sidebarLink = document.querySelectorAll(".sidebar-link ");

                if (isSidebarExpanded) { //Mở sidebar
                    sidebarLogo.classList.remove('w-0', 'h-0');
                    sidebarLogo.classList.add('w-full', 'flex', 'p-4');
                    sidebarSection.classList.remove('w-0');
                    sidebarSection.classList.add('w-32', 'flex-1');
                    Array.from(sidebarItems).forEach(item => {
                        item.classList.remove("w-0");
                        item.classList.add("w-40", "ml-3");
                    });
                    sidebarUserInfo.classList.remove('w-0');
                    sidebarUserInfo.classList.add("ml-3", "flex-1");
                    sidebarButton.classList.remove('w-0');
                    sidebarButton.classList.add("ml-2", "w-10");
                    sidebarExpanded.classList.remove("hidden");
                    sidebarCollapsed.classList.add("hidden");
                    Array.from(sidebarLink).forEach(item => item.classList.remove("justify-center"));
                } else { //Đóng sidebar
                    sidebarLogo.classList.remove('w-full', 'flex', 'p-4');
                    sidebarLogo.classList.add('w-0', 'h-0');
                    sidebarSection.classList.remove('w-32', 'flex-1');
                    sidebarSection.classList.add('w-0');
                    Array.from(sidebarItems).forEach(item => {
                        item.classList.remove("w-40", "ml-3");
                        item.classList.add("w-0");
                    });
                    sidebarUserInfo.classList.remove("ml-3", "flex-1");
                    sidebarUserInfo.classList.add('w-0');
                    sidebarButton.classList.remove("ml-2", "w-10");
                    sidebarButton.classList.add('w-0');
                    sidebarCollapsed.classList.remove("hidden");
                    sidebarExpanded.classList.add("hidden");
                    Array.from(sidebarLink).forEach(item => item.classList.add("justify-center"));
                }
            }
        </script>
    </head>
    <body>
        <c:if test="${!pageContext.request.servletPath.contains('/auth')}">
            <header class="fixed w-full top-0 z-50 bg-white/90 backdrop-blur-sm border-b border-slate-200 ${empty currentUser ? '' : 'hidden'}">
                <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                    <div class="flex justify-between items-center h-16">
                        <jsp:include page="/assets/icon/logo.jsp"/>
                        <div class="hidden md:flex items-center space-x-4">
                            <a href="${pageContext.request.contextPath}/auth/login" class="text-slate-600 hover:text-brand-red font-medium px-3 py-2">Đăng nhập</a>
                            <a href="${pageContext.request.contextPath}/auth/register" class="bg-rose-400 hover:bg-rose-700 text-white px-5 py-2.5 rounded-full font-medium transition shadow-lg shadow-rose-500/30">
                                Đăng ký miễn phí
                            </a>
                        </div>
                    </div>
                </div>
            </header>
        </c:if>
        <div class="h-screen flex">
            <aside class="transition-all duration-300 inline-flex flex-col border-r border-gray-300 shadow-lg bg-rose-200 ${not empty currentUser ? '' : '!hidden'}">
                <div id="sidebar-logo" class="transition-all duration-300 w-full p-4 pb-2 flex justify-center overflow-hidden">
                    <jsp:include page="/assets/icon/logo.jsp"/>
                </div>
                <div class="p-4 pb-2 flex justify-between items-center">
                    <p id="sidebar-section" class="transition-all duration-300 overflow-hidden text-center font-bold text-lg flex-1 w-32">
                        Danh mục
                    </p>
                    <ui:button className="cursor-pointer" variant="secondary" size="icon" onclick="toggleSidebar()">
                        <div id="sidebar-expanded">
                            <jsp:include page="/assets/icon/chevronFirst.jsp">
                                <jsp:param name="size" value="6"/>
                            </jsp:include>
                        </div>
                        <div id="sidebar-collapsed" class="hidden">
                            <jsp:include page="/assets/icon/menu.jsp">
                                <jsp:param name="size" value="6"/>
                            </jsp:include>
                        </div>
                    </ui:button>
                </div>

                <ul class="flex-1 overflow-y-auto px-3 scrollbar-hide">
                    <c:if test="${currentUser.getRole() == RoleConstant.LEARNER}">
                        <li>
                            <a href="${pageContext.request.contextPath}/flashcard" class="sidebar-link flex items-center py-2 px-3 my-1 font-medium rounded-md cursor-pointer transition-colors leading-4 group hover:bg-rose-400 text-gray-600">
                                <i class="fa-solid fa-layer-group text-rose-500"></i>
                                <span class="sidebar-item whitespace-nowrap overflow-hidden transition-all duration-300 leading-7 w-40 ml-3">
                                    Bộ thẻ Flashcard
                                </span>
                            </a>
                        </li>
                    </c:if>
                    <c:if test="${currentUser.getRole() == RoleConstant.ADMIN}">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/flashcard-groups" class="sidebar-link flex items-center py-2 px-3 my-1 font-medium rounded-md cursor-pointer transition-colors leading-4 group hover:bg-rose-400 text-gray-600">
                                <i class="fa-solid fa-layer-group text-rose-500"></i>
                                <span class="sidebar-item whitespace-nowrap overflow-hidden transition-all duration-300 leading-7 w-40 ml-3">
                                    Quản lý bộ thẻ
                                </span>
                            </a>
                        </li>
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/lesson-groups" class="sidebar-link flex items-center py-2 px-3 my-1 font-medium rounded-md cursor-pointer transition-colors leading-4 group hover:bg-rose-400 text-gray-600">
                                <i class="fa-solid fa-graduation-cap text-rose-500"></i>
                                <span class="sidebar-item whitespace-nowrap overflow-hidden transition-all duration-300 leading-7 w-40 ml-3">
                                    Quản lý bài học
                                </span>
                            </a>
                        </li>
                    </c:if>
                </ul>

                <div class="p-2 text-gray-500 border-t border-gray-300 flex justify-center items-center">
                    <div class="size-8 rounded-full bg-gray-200 flex items-center justify-center text-gray-500">
                        <c:choose>
                            <c:when test="${not empty currentUser.googleId}">
                                <i class="fa-brands fa-google"></i>
                            </c:when>
                            <c:otherwise>
                                <i class="fa-solid fa-user"></i>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div id="sidebar-user-info" class="flex items-center transition-all duration-300 overflow-hidden ml-3 flex-1">
                        <div class="w-40">
                            <p class="font-bold truncate">${currentUser.getFullName()}</p>
                            <p class="text-sm text-gray-600 truncate">
                                ${currentUser.getEmail()}
                            </p>
                        </div>
                    </div>
                    <ui:button variant="ghost" className="sidebar-button hover:!bg-rose-700 hover:text-white overflow-hidden ml-2 w-10" size="icon" onclick="location.href='${pageContext.request.contextPath}/user/profile'">
                        <jsp:include page="/assets/icon/ellipsisVertical.jsp">
                            <jsp:param name="size" value="4"/>
                        </jsp:include>
                    </ui:button>
                </div>
            </aside>
            <main class="flex-1 bg-gray-50 overflow-y-auto scroll-smooth ${not empty currentUser || pageContext.request.servletPath.contains('/auth') ? '' : 'pt-16'}">
                <jsp:doBody />
            </main>
        </div>
    </body>
</html>